//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import SwiftUI
import CallKit

struct IncomingInterfaceView: View {
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    @Binding var isAnyCallPanding: Bool
    @ObservedObject var receivedEndCall: ReceivedEndCall
    @Binding var receiverID: String
    @EnvironmentObject var callManager: CallManager
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
    @EnvironmentObject var callHistoryManager: CallHistoryManager
    @State var showToast: Bool = false
    @State var isPermission:Bool = false
    @State var errorMessage: String = ""
    
    let acceptPublishser = NotificationCenter.default
        .publisher(for: Notification.Name.DidCallAccepted)
    
    var body: some View {
        HStack {}
        .onReceive(self.acceptPublishser) { hasPermission in
            if let hasPer = hasPermission.object as? String{
                DispatchQueue.main.async {
                    errorMessage = hasPer
                    isPermission = true
                    showToast = true
                }
                guard let callID = callHistoryManager.callID else{return}
                receivedEndCall.endCall(callID: callID)
            }else{
                self.hasActivateCall = true
                receivedEndCall.providerDelegate.connectedCall(with: self.callID ?? UUID())
        }
    }
        .onAppear{
            //event funtion from incoming calling pjsip
            NotificationCenter.default.addObserver(forName: Notification.Name("IncomingCall"), object: nil, queue: nil) { notification in
                if let sipDomain = notification.object as? String {
                    // callkit function
                    guard let callerNumber = getCallNumber(sipDomain: sipDomain) else{return}
                    DispatchQueue.main.async {
                        if callID == nil{
                            let uuid = UUID()
                            self.callID = uuid
                        }
                        receivedEndCall.receiveCall(from: callerNumber, hasVideo: callManagerPJSIP.isVideoCall, callID: self.callID ?? UUID())
                        receiverID = callerNumber
                        isAnyCallPanding = true
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
    
    func getCallNumber(sipDomain: String) -> String?{
        if let range = sipDomain.range(of: "\\d+", options: .regularExpression) {
            let extractedNumber = sipDomain[range]
            print(extractedNumber)
            return String(extractedNumber)
        } else {
            print("No number found.")
            return nil
        }
    }
}
