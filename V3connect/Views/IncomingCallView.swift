//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

struct IncomingCallView: View {
    @ObservedObject var callManager: CallManagerPJSIP
    let callerNumber: String
    @Binding var showIncomingView:Bool
    
    var body: some View {
        VStack {
            Text("Incoming Call from: \(callerNumber)")
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
            HStack{
                Spacer()
                Button("Answer Call") {
                    callManager.pickUPCall()
                }
                Spacer()
                Button("End Call") {
                    callManager.endCall()
                    showIncomingView = false
                }
                Spacer()
            }
            .padding()
        }
    }
}

