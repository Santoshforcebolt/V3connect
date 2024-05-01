//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import AVFoundation
import UIKit
import CallKit

typealias ErrorHandler = ((NSError?) -> ())


extension Notification.Name {
    static let DidCallEnd = Notification.Name("DidCallEnd")
    static let DidCallAccepted = Notification.Name("DidCallAccepted")
}

class ProviderDelegate: NSObject, CXProviderDelegate {
    let callManagerPJSIP = CallManagerPJSIP.shared
    let callHistoryManager = CallHistoryManager.shared
    var callManager = CallManager.shared
 
    private let provider: CXProvider
    static let shared = ProviderDelegate()
    
    override init() {
        provider = CXProvider.custom
        super.init()
        // if queue value is nil, delegate will run on main thread
        provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(with uuid: UUID, remoteUserID: String, hasVideo: Bool, completionHandler: ErrorHandler? = nil) {
        // Update call based on DirectCall object
        let update = CXCallUpdate()
        update.update(with: remoteUserID, hasVideo: hasVideo, incoming: true)
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            guard error == nil else {
                completionHandler?(error as NSError?)
                return
            }
            // Add call to call manager
            self.callManager.addCall(uuid: uuid)
        }
    }
    
    func reportIncomingCall(with uuid: UUID) {
        // Update call based on DirectCall object
        let update = CXCallUpdate()
        update.onFailed(with: uuid)
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            self.provider.reportCall(with: uuid, endedAt: Date(), reason: .failed)
        }
    }
    
    func reportOutgoingCall(with uuid: UUID) {
        // Update call based on DirectCall object
        provider.reportOutgoingCall(with: uuid, connectedAt: nil)
    }
    
    func endCall(with uuid: UUID, endedAt: Date, reason: CXCallEndedReason) {
        self.provider.reportCall(with: uuid, endedAt: endedAt, reason: reason)
    }
    
    func connectedCall(with uuid: UUID) {
        self.provider.reportOutgoingCall(with: uuid, connectedAt: Date())
    }
    
    func providerDidReset(_ provider: CXProvider) {
        // 1. Stop audio
        
        // 2. End all calls because they are no longer valid
        // CODE HERE
        for call in callManager.callIDs{
            callManager.endCall(with: call)
        }
        
        // 3. Remove all calls from the app's list of call
        self.callManager.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        configureAudioSession(enabled: false)
        self.callManager.addCall(uuid: action.callUUID)
        self.connectedCall(with: action.callUUID)
        callManagerPJSIP.outgoingCalling(receiverID: callManagerPJSIP.receiverID)
        NotificationCenter.default.addObserver(forName: Notification.Name("DidConnect"), object: nil, queue: nil) { notification in
            if notification.object is String {}
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // configure audio session
        // Accept call
        // Notify incoming call accepted if it's required.
        
        var hasPermission:String? = nil
        if callManagerPJSIP.isVideoCall{
            if callManager.askMicrophoneAuthorization() && callManager.askVideoAuthorization(){
                isPermissionPickUpCall(speakerEnable: true)
            }else{
              hasPermission = "To place calls,V3Connect needs access to your iPhone's microphone. Tap Settings and turn on Camera and Microphone."
            }
        }else {
            if callManager.askMicrophoneAuthorization(){
                isPermissionPickUpCall(speakerEnable: false)
            }else{
              hasPermission = "To place calls,V3Connect needs access to your iPhone's microphone. Tap Settings and turn on Microphone."
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.DidCallAccepted, object: hasPermission)
        
        func isPermissionPickUpCall(speakerEnable: Bool){
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.callManagerPJSIP.pickUPCall()
            }
            self.configureAudioSession(enabled: speakerEnable)
            action.fulfill()
            return
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        if callManagerPJSIP.isOutgoingcallHangup{
            callManagerPJSIP.endCall()
        }
        NotificationCenter.default.post(name: NSNotification.Name.DidCallEnd, object: nil)
        self.callManager.removeAllCalls()
        callHistoryManager.addCall(name: callManagerPJSIP.receiverID, callTime: Date())
        action.fulfill()
        return
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        // update holding state
        switch action.isOnHold {
        case true:
            // Stop audio
            // Stop video
            action.fulfill()
        case false:
            // Play audio
            // Play video
            action.fulfill()
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        callManagerPJSIP.activateSipSoundDevices()
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        callManagerPJSIP.deactivateSipSoundDevices()
    }
    
    func configureAudioSession(enabled: Bool) {
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.playAndRecord,
                                    mode: AVAudioSession.Mode.voiceChat,
                                     options: [])
            if enabled {
                try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } else {
                try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
            }
            
        } catch {
            print("========== Error in setting category \(error.localizedDescription)")
        }
        do {
            try session.setPreferredSampleRate(44100.0)
        } catch {
            print("======== Error setting rate \(error.localizedDescription)")
        }
        do {
            try session.setPreferredIOBufferDuration(0.005)
        } catch {
            print("======== Error IOBufferDuration \(error.localizedDescription)")
        }
        do {
            try session.setActive(true)
        } catch {
            print("========== Error starting session \(error.localizedDescription)")
        }
    }
}
