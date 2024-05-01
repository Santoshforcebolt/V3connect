//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//
import SwiftUI

struct DialView: View {
    // Access `CallManager.shared` singleton
    @EnvironmentObject var callManager: CallManager
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
    @ObservedObject var registerWithPJSIP: RegisterWithPJSIP
    @EnvironmentObject var callHistoryManager: CallHistoryManager
    @ObservedObject var receivedEndCall: ReceivedEndCall
//  @EnvironmentObject var vinfo: VidInfo
    @State var lastRecentCallID = ""
    @State var textReceiverID = ""
    @State var statusMessage = ""
    @State var showingAlert = false
    @State var isOffline = false
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Text("V3Connect")
                .font(.title)
                .bold()
                .padding(.vertical, 112)
            
            AvailableStatusView()
                .padding(.bottom, 40)
            if(!callManagerPJSIP.isOffline){
                VStack{
                    HStack {
                        Image(systemName: "person").foregroundColor(.gray)
                        TextField("Receiver ID", text: $textReceiverID)
                            .font(.body)
                            .keyboardType(.phonePad)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    if callHistoryManager.hasActivateCall {
                        // MARK: Handle a call
                        
//                        Color(.black)
//                            .frame(width: 176, height: 64)
//                            .cornerRadius(32)
//                            .overlay(
//                                CallInterfaceView(hasActivateCall: $callHistoryManager.hasActivateCall, callID: $callHistoryManager.callID)
//                            )
//
                    }
                    else {
                        // MARK: Make a call
                        
                        HStack {
                            Color(.blue)
                                .frame(width: 64, height: 64)
                                .cornerRadius(32)
                                .overlay(
                                    OutgoingInterfaceView(receiverID: $textReceiverID,
                                                          hasActivateCall: $callHistoryManager.hasActivateCall,
                                                          callID: $callHistoryManager.callID, isAnyCallPanding:$callHistoryManager.isAnyCallPanding, lastRecentCallID: $lastRecentCallID, hasVideo: false, receivedEndCall: receivedEndCall)
                                    .foregroundColor(.white)
                                )
                                .padding(.horizontal, 24)
                            
                            Color(.blue)
                                .frame(width: 64, height: 64)
                                .cornerRadius(32)
                                .overlay(
                                    OutgoingInterfaceView(receiverID: $textReceiverID,
                                                          hasActivateCall: $callHistoryManager.hasActivateCall,
                                                          callID: $callHistoryManager.callID, isAnyCallPanding:$callHistoryManager .isAnyCallPanding, lastRecentCallID: $lastRecentCallID, hasVideo: true, receivedEndCall: receivedEndCall)
                                    .foregroundColor(.white)
                                )
                                .padding(.horizontal, 24)
                            IncomingInterfaceView(hasActivateCall: $callHistoryManager.hasActivateCall,
                                                  callID: $callHistoryManager.callID,isAnyCallPanding:$callHistoryManager .isAnyCallPanding, receivedEndCall: receivedEndCall, receiverID: $callManagerPJSIP.receiverID)
                        }
                    }
                }
            }else{
                Text("You are in offline mode,For incoming and outgoing call.Please change your status Available")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            Spacer()
        }.onAppear{
            let _ = callManager.askMicrophoneAuthorization()
            NotificationCenter.default.addObserver(forName: Notification.Name("Disconnected"), object: nil, queue: nil) { notification in
                if let message = notification.object as? String {
                    DispatchQueue.main.async {
                        self.statusMessage = message
                        afterDisconnected()
                    }
                }
            }
        }
        .toast(message: statusMessage,
               isShowing: $showingAlert,
               duration: Toast.short)
        
        .background()
        .dismissKeyboardOnTap()
    }
    func afterDisconnected(){
        callHistoryManager.hasActivateCall = false
        self.showingAlert = true
        callHistoryManager.isAnyCallPanding = false
    }
}

