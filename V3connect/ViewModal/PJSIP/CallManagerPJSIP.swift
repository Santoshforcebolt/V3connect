//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
import AVFoundation
import CallKit

@available(iOS 13.0, *)
class CallManagerPJSIP: ObservableObject {
    @Published var receiverID: String = ""
    @Published var isOffline: Bool = false
    @Published var state: ConnectivityStateEnum = .available
    @Published var isVideoCall = false
    @Published var isOutgoingcallHangup = false
    static let shared = CallManagerPJSIP()
    let callKitWrapper = CallKitWrapper()
    private init() {}
    
    func  registerPJSIP(userName: String,sipDomain: String,password: String,isRegister: Bool,handle: @escaping ((Bool, String)->Void)) {
        let callback = { statusCode in
            var isSuccess = false
            var message = ""
            
            if statusCode == 200 {
                isSuccess = true
                message = "Registration successful"
            } else{
                isSuccess = false
                message = "Invalid Credential"
            }
            
            // Call the provided handle closure with the success flag and message
            handle(isSuccess, message)
        }
        let _ = startPjsipAndRegister(onServer: sipDomain, withUserName: userName, andPassword: password, shouldRegisterOnStartup: isRegister, callback: callback)
    }
    
    func unregisterPJSIP() {
        callKitWrapper.unRegisterSIP()
    }
    
    func reRegisterPJSIP(handle: @escaping (()->Void)) {
        callKitWrapper.reRegisterSIP()
        handle()
    }
    
    // calling to another person
    func outgoingCalling(receiverID: String) {
        let destID = "sip:\(receiverID)@12.152.71.226:5060"
        callKitWrapper.makeCall(dest: destID, isVideoCall: isVideoCall)
    }
    
    func endCall(){
        callKitWrapper.endCall()
    }
    
    func pickUPCall(){
        self.callKitWrapper.pickUPCall()
    }
    
    func activateSipSoundDevices() {
        callKitWrapper.activateSipSoundDevices()
    }
    
    func deactivateSipSoundDevices() {
        callKitWrapper.deactivateSipSoundDevices()
    }
    
    func logout(handle: @escaping (()->Void)){
        callKitWrapper.logoutPJSIP()
        handle()
    }
    
    func flipCamera(isBackCamara: Bool){
        callKitWrapper.flipCamera(isBackCamara: isBackCamara)
    }
    
    func dtmfDigit(digit: String){
        callKitWrapper.sendDTMFDigits(digits: digit)
    }
    
    func playDTMFDigit(digit: String){
//        callKitWrapper.callPlayDigit(digits: digit)
    }
}



