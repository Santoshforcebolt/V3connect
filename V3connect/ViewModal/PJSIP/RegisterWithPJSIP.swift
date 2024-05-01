//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

class RegisterWithPJSIP: ObservableObject{
    @AppStorage("userName") var userName: String = ""
    @AppStorage("sipDomain") var sipDomain: String = ""
    @AppStorage("password") var password: String = ""
    @AppStorage("isRegistered") var isRegistered = false
    @Published var pushkitdeviceID: String = ""
    @Published var regularPushNotifatonID: String = ""
    static let shared = RegisterWithPJSIP()
    let callManagerPJSIP = CallManagerPJSIP.shared
    let status = ""
    
    func register(handle: @escaping (Bool,String)-> Void){
        if userName == ""{
            handle(false,"Please enter your Username")
        }else if sipDomain == ""{
            handle(false,"Please enter your Sip Domain")
        }else if password == ""{
            handle(false,"Please enter your Password")
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                self.callManagerPJSIP.registerPJSIP(userName: self.userName, sipDomain: self.sipDomain, password: self.password, isRegister: false) { isSuccess,message in
//                    if isSuccess{
//                        let param = [
//                            "userID"   : self.userName,
//                            "pushkitdeviceID" : self.pushkitdeviceID,
//                            "regularPushNotifatonID" : self.regularPushNotifatonID
//                        ]
//                        ApiProviderImpl.instance.voipDeviceTokenApi.voipDeviceToken(params: param) { response, error in
//                            if error != nil {
//                                print("Error: \(String(describing: error?.localizedDescription))")
//                                handle(false,"Something went wrong! Please try again!")
//                            }else{
//                                
//                                print("Voip ID save response: \(String(describing: response)) and \(self.userName)")
                                handle(isSuccess,message)
//                            }
//                        }
//                    }
                }
            }
        }
    }
}
