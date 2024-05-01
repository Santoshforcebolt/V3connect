//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

struct PresentVideoView: View {
    @State var textDMTCID = ""
    @State var message = ""
    @State var showingAlert = false
    @EnvironmentObject var callManagarPJSIP: CallManagerPJSIP
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "person").foregroundColor(.gray)
                TextField("", text: $textDMTCID, prompt: Text("DTMF Digit").foregroundColor(Color.white.opacity(0.5)))
                    .foregroundColor(.white)
                    .font(.body)
                    .keyboardType(.phonePad)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray, lineWidth: 1))
            .padding([.horizontal], 24)
            .onChange(of: textDMTCID) { newValue in
                    callManagarPJSIP.playDTMFDigit(digit: textDMTCID)
            }
            
            Button {
                if(textDMTCID != ""){
                    callManagarPJSIP.dtmfDigit(digit: textDMTCID)
                }else{
                    message = "Please provide the DMTC ID"
                    showingAlert = true
                    print("Please provide DMTC ID")
                }
            } label: {
                Text("Send")
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                    )
            }
        }.toast(message: message,
                 isShowing: $showingAlert,
                 duration: Toast.short)
    }
}

struct PresentVideoVIew_Previews: PreviewProvider {
    static var previews: some View {
        PresentVideoView()
    }
}
