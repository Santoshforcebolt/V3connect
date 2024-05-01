//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
import SwiftUI
import CallKit

class ReceivedEndCall: ObservableObject{
    let providerDelegate = ProviderDelegate.shared
    let callManager = CallManager.shared
    static let shared = ReceivedEndCall()
    let callHistoryManager = CallHistoryManager.shared
    let callManagarPJSIP = CallManagerPJSIP.shared
    
    func receiveCall(from callerID: String, hasVideo: Bool,callID: UUID) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: callerID)
        self.providerDelegate.reportIncomingCall(with: callID, remoteUserID: callerID, hasVideo: hasVideo) { error in
            if let error = error { print(error.localizedDescription) }
            else { print("Ring Ring...") }
        }
    }
    
    func startCall(to receiverID: String, hasVideo: Bool,callID: UUID,completion: @escaping (Bool) -> Void) {
        print("Your receiverID:\(receiverID)")
        self.callManager.startCall(with: callID, receiverID: receiverID, hasVideo: hasVideo) { error in
            if let error = error { print(error.localizedDescription) }
            else { completion(true) }
        }
    }
    
    func endCall(callID: UUID) {
        self.callManager.endCall(with: callID) { error in
            DispatchQueue.main.async {
                if let error = error { print(error.localizedDescription) }
                else { self.callHistoryManager.hasActivateCall = false }
            }
        }
    }
}
