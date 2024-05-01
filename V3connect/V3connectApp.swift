//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

@available(iOS 14.0, *)
@main
struct V3connectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var registerWithPJSIP = RegisterWithPJSIP.shared
    
    init(){
        NetworkMonitor.shared.startMonitoring()
    }
    var body: some Scene {
        WindowGroup {
            if !registerWithPJSIP.isRegistered{
                ContentView(registerWithPJSIP: registerWithPJSIP)
                    .environmentObject(CallManager.shared)
                    .environmentObject(CallManagerPJSIP.shared)
                    .environmentObject(CallHistoryManager.shared)
                    .environmentObject(VidInfo.shared)
                   
            }else{
                TabBarView(registerWithPJSIP: registerWithPJSIP)
                    .environmentObject(CallManager.shared)
                    .environmentObject(CallManagerPJSIP.shared)
                    .environmentObject(CallHistoryManager.shared)
                    .environmentObject(VidInfo.shared)
            }
        }
    }
}
