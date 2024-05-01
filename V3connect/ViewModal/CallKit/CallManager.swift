//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import CallKit
import Combine
import AVFoundation

class CallManager: NSObject, ObservableObject {
    static let shared = CallManager()
    let callManagerPJSIP = CallManagerPJSIP.shared
    let callController = CXCallController()
    private(set) var callIDs: [UUID] = []
    
    // MARK: Actions
    // 1. Make action
    // 2. Make CXTransaction object
    // 3. request the transaction
    
    func startCall(with uuid: UUID, receiverID: String, hasVideo: Bool, completionHandler: ErrorHandler? = nil) {
        let handle = CXHandle(type: .generic, value: receiverID)
        
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        startCallAction.isVideo = hasVideo
        callManagerPJSIP.isVideoCall = hasVideo
        
        let transaction = CXTransaction(action: startCallAction)
        self.requestTransaction(transaction, completionHandler: completionHandler)
    }
    
    func endCall(with uuid: UUID, completionHandler: ErrorHandler? = nil) {
        let endCallAction = CXEndCallAction(call: uuid)
        
        let transaction = CXTransaction(action: endCallAction)
        self.requestTransaction(transaction, completionHandler: completionHandler)
    }
    
    func setHeldCall(with uuid: UUID, onHold: Bool, completionHandler: ErrorHandler?) {
        let setHeldCallAction = CXSetHeldCallAction(call: uuid, onHold: onHold)
        
        let transaction = CXTransaction(action: setHeldCallAction)
        self.requestTransaction(transaction, completionHandler: completionHandler)
    }
    
    func muteCall(with uuid: UUID, muted: Bool, completionHandler: ErrorHandler?) {
        let muteCallAction = CXSetMutedCallAction(call: uuid, muted: muted)
        
        let transaction = CXTransaction(action: muteCallAction)
        self.requestTransaction(transaction, completionHandler: completionHandler)
    }
    
    private func requestTransaction(_ transaction: CXTransaction, completionHandler: ErrorHandler?) {
        callController.request(transaction) { error in
            guard error == nil else {
                print("Error requesting transaction: \(error?.localizedDescription ?? "")")
                completionHandler?(error as NSError?)
                return
            }
            print("Requested transaction successfully")
            completionHandler?(nil)
        }
    }
    
    public func askMicrophoneAuthorization() -> Bool{
        let recordingSession = AVAudioSession.sharedInstance()
        var isAudioGranted = false

        switch recordingSession.recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                // Handle granted
                isAudioGranted = true
               let _ = self.askVideoAuthorization()
            })
            break
            
        case .denied:
            isAudioGranted = false
            break
            
        case .granted:
            isAudioGranted = true
            break
            
        @unknown default:
            print("Unknown case")
        }
        return isAudioGranted
    }
    
    public func askVideoAuthorization() -> Bool{
        var isVideoGranted = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            isVideoGranted = false
            break
            
        case .restricted:
            print("Restricted, device owner must approve")
            isVideoGranted = false
            break
            
        case .authorized:
            print("Authorized, proceed")
            isVideoGranted = true
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    isVideoGranted = true
                } else {
                    print("Permission denied")
                    isVideoGranted = false
                }
            }
            break
            
        @unknown default:
            print("Unknown case")
        }
        return isVideoGranted
    }
    
    // MARK: Call Management
    func addCall(uuid: UUID) {
        self.callIDs.append(uuid)
    }
    
    func removeCall(uuid: UUID) {
        self.callIDs.removeAll { $0 == uuid }
    }
    
    func removeAllCalls() {
        self.callIDs.removeAll()
    }
}
