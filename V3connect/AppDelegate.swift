//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import UIKit
import PushKit
import CallKit
import UserNotifications
import AVFoundation

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var pushRegistry: PKPushRegistry?
    let receivedEndCall = ReceivedEndCall.shared
    let registerWithPJSIP = RegisterWithPJSIP.shared
    let callManagerPJSIP = CallManagerPJSIP.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register for VoIP push notifications
        voipRegistration()
        permissionNotification()
        return true
    }
    
    func permissionNotification(){
              UNUserNotificationCenter.current().delegate = self
              UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                  (granted, error) in
                  print("Permission granted: \(granted)")
                  // 1. Check if permission granted
                  guard granted else { return }
                  // 2. Attempt registration for remote notifications on the main thread
                  DispatchQueue.main.async {
                      UIApplication.shared.registerForRemoteNotifications()
                  }
              }
    }
    
        // Register for VoIP notifications
        func voipRegistration() {
            // Create a push registry object
            let voipQueue = DispatchQueue.main
            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: voipQueue)
            voipRegistry.delegate = self
            voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        }

}

// MARK: - PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("Token",credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        print("pushRegistry -> deviceToken :\(deviceToken)")
        registerWithPJSIP.pushkitdeviceID = deviceToken
    }

//    @available(iOS, introduced: 8.0, deprecated: 11.0)
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        self.handlePushPayload(payload)
//    }
//    @available(iOS 11.0, *)
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if UIApplication.shared.applicationState != UIApplication.State.active {
            if let alertBody = payload.dictionaryPayload["aps"] as? [String: Any],
               let alert = alertBody["alert"] as? [String: Any],
               let body = alert["body"] as? String {
                print("Received VoIP push notification with body: \(body)")
                let bgTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                self.receivedEndCall.receiveCall(from: body, hasVideo: false, callID: UUID())
                DispatchQueue.main.async {
                    self.callManagerPJSIP.receiverID = body
                }
                NSLog("Arrived VoIP Notification: \(payload.dictionaryPayload)")
                UIApplication.shared.endBackgroundTask(bgTaskID)
            }
            completion()
        }
    }
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        NSLog("Token Invalidate")
    }
//    func handlePushPayload(_ payload: PKPushPayload) {
//        
//        /*
//         Arrived VoIP Notification: [AnyHashable("aps"): {
//             alert =     {
//                 body = Abhishek;
//                 subtitle = subtitle;
//                 title = title;
//             };
//         }]
//         */
//        if UIApplication.shared.applicationState != UIApplication.State.active {
//            if(registerWithPJSIP.isRegistered){
//                if let alertBody = payload.dictionaryPayload["aps"] as? [String: Any],
//                   let alert = alertBody["alert"] as? [String: Any],
//                   let body = alert["body"] as? String {
//                    print("Received VoIP push notification with body: \(body)")
//                    self.receivedEndCall.receiveCall(from: body, hasVideo: false, callID: UUID())
//                    callManagerPJSIP.receiverID = body
//                }
//            }else{
//                print("isRegistered: \(registerWithPJSIP.isRegistered)")
//            }
//        }
//         NSLog("Arrived VoIP Notification: \(payload.dictionaryPayload)")
//    }
}

// MARK: - PushNotificationDelegate
extension AppDelegate: UNUserNotificationCenterDelegate{
    // Remote Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         // 1. Convert device token to string
         let tokenParts = deviceToken.map { data -> String in
             return String(format: "%02.2hhx", data)
         }
         let token = tokenParts.joined()
         // 2. Print device token to use for PNs payloads
        registerWithPJSIP.regularPushNotifatonID = token
         print("Device Token for Push Notification: \(token)")
     }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         // 1. Print out error if PNs registration not successful
         print("Failed to register for remote notifications with error: \(error)")
     }
}

