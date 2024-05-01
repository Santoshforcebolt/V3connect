//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import SwiftUI

struct CallInterfaceView: View {
    @EnvironmentObject var callManager: CallManager
    @EnvironmentObject var callManagarPJSIP: CallManagerPJSIP
    @ObservedObject var receivedEndCall: ReceivedEndCall
    @Binding var hasActivateCall: Bool
    @Binding var callID: UUID?
    @Binding var isAnyCallPanding: Bool
    @State var isMuted: Bool = false
    @State var isfliped: Bool = false
    @State var rotateTime = 1
    @State var isSpeakerOn = false
    
    var body: some View {
        HStack {
            Button(action: self.muteAudio) {
                Image(systemName: self.isMuted ? "mic.slash.fill" : "mic.fill")
                    .frame(height: 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().fill(Color.blue))
            }
            
            Button(action: {
                self.isSpeakerOn.toggle()
                ProviderDelegate.shared.configureAudioSession(enabled: isSpeakerOn)
            }, label: {
                Image(systemName: isSpeakerOn ? "speaker.slash.fill" : "speaker.wave.3.fill")
                    .frame(height: 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().fill(Color.blue))
            })
            
            if callManagarPJSIP.isVideoCall{
                Button(action: self.flipCamara) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .frame(height: 10)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Circle().fill(Color.blue))
                }
            }
            
            
            Button {
                isAnyCallPanding = false
                guard let callID = self.callID else { return }
                callManagarPJSIP.isOutgoingcallHangup = true
                receivedEndCall.endCall(callID: callID)
            } label: {
                Image(systemName: "phone.down.fill")
                    .frame(height: 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().fill(Color.red))
            }
        }
    }
    
    func flipCamara(){
        self.isfliped.toggle()
        callManagarPJSIP.flipCamera(isBackCamara: self.isfliped)
    }
    
    //    func moveLocalView(){
    //        switch(rotateTime){
    //        case 0:
    //            move = .bottomLeading
    //            break
    //        case 1:
    //            move = .bottomTrailing
    //            break
    //        case 2:
    //            move = .topLeading
    //            break
    //        case 3:
    //            move = .topTrailing
    //            break
    //        default:
    //            break
    //        }
    //        rotateTime += 1
    //        rotateTime %= 4
    //    }
    
    
    func muteAudio() {
        self.isMuted.toggle()
        guard let callID = self.callID else { return }
        self.callManager.muteCall(with: callID, muted: self.isMuted) { error in
            if let error = error { print(error.localizedDescription) }
            else { print("Audio On/Off state has been cahnged successfully") }
        }
    }
}
