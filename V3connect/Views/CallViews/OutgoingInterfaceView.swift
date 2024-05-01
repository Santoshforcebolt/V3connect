//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import SwiftUI

struct OutgoingInterfaceView: View {
    @EnvironmentObject var callManager: CallManager
    @Binding var receiverID: String
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    @Binding var isAnyCallPanding: Bool
    @State var showToast: Bool = false
    @State var isPermission:Bool = false
    @State var errorMessage: String = ""
    @Binding var lastRecentCallID: String
    let hasVideo: Bool
    @ObservedObject var receivedEndCall: ReceivedEndCall
    @EnvironmentObject var callHistoryManager: CallHistoryManager
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
    let acceptPublishser = NotificationCenter.default
        .publisher(for: Notification.Name.DidCallAccepted)
    
    var body: some View {
        HStack {
            // MARK: Voice Call
            Image(systemName: hasVideo ? "video.fill" : "phone.fill.arrow.up.right")
                .onTapGesture {
                    if !NetworkMonitor.shared.isReachable{
                        errorMessage = NetworkMonitor.shared.message
                        showToast = true
                    }else if isAnyCallPanding{
                        errorMessage = "Can't place a new call while you're already in a call"
                        showToast = true
                    }else if receiverID == ""{
                        errorMessage = "Please provide receiver ID"
                        showToast = true
                    }else if !callManager.askMicrophoneAuthorization(){
                        errorMessage = "To place calls,V3Connect needs access to your iPhone's microphone. Tap Settings and turn on Microphone."
                        isPermission = true
                        showToast = true
                    }else if !callManager.askVideoAuthorization() && hasVideo{
                        errorMessage = "To place calls,V3Connect needs access to your iPhone's Camera. Tap Settings and turn on Camera."
                        isPermission = true
                        showToast = true
                    }else{
                        lastRecentCallID = self.$receiverID.wrappedValue
                        callManagerPJSIP.receiverID = self.$receiverID.wrappedValue
                        if callID == nil{
                            let uuid = UUID()
                            self.callID = uuid
                        }
                        receivedEndCall.startCall(to: self.$receiverID.wrappedValue, hasVideo: hasVideo, callID: self.callID ?? UUID()) { status in
                            DispatchQueue.main.async {
                                self.hasActivateCall = status
                                isAnyCallPanding = true
                            }
                        }
                    }
                }
            }
        .alert(errorMessage, isPresented: $showToast) {
            if isPermission{
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                       UIApplication.shared.open(settingsUrl)
                     }
                }
            }
            Button(isPermission ? "Cancel" : "OK", role: .cancel) { }
        }
    }
}
