//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI
import AVKit

struct TabBarView: View {
    @ObservedObject var registerWithPJSIP: RegisterWithPJSIP
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
    @EnvironmentObject var callHistoryManager: CallHistoryManager
    @EnvironmentObject var callManager: CallManager
    @EnvironmentObject var vinfo: VidInfo
    @StateObject var receivedEndCall = ReceivedEndCall()
    @State var lastRecentCallID = ""
    @State var statusMessage = ""
    @State var showingAlert = false
    @State var showingSheet = true
    @State var move:Alignment = .topLeading
    @State var viewState = CGSize.zero
    @State var targetPosition: CGSize = .zero
    @State private var pipController: AVPictureInPictureController!
    @State private var pipVideoCallViewController: AVPictureInPictureVideoCallViewController!
    
    var body: some View {
        ZStack{
            if (!callHistoryManager.hasActivateCall){
                TabView {
                    // DialView Tab
                    NavigationView {
                        VStack{
                            Divider()
                            DialView(registerWithPJSIP: registerWithPJSIP, receivedEndCall: receivedEndCall, lastRecentCallID: lastRecentCallID)
                        }
                        .navigationBarTitle("Dial", displayMode: .inline)
                    }.tag(0)
                        .tabItem {
                            Image(systemName: "apps.iphone.badge.plus")
                            Text("Dial")
                        }
                    
                    //  CallHistory Tab
                    NavigationView {
                        CallHistoryView()
                            .navigationBarTitle("Recents", displayMode: .inline)
                    }.tag(1)
                        .tabItem {
                            Image(systemName: "clock.fill")
                            Text("Recents")
                        }
                    
                    // Setting Tab
                    NavigationView {
                        VStack{
                            Divider()
                            SettingViewLoader(registerWithPJSIP: registerWithPJSIP, isOffline: .constant(false))
                        }
                        .navigationBarTitle("Settings", displayMode: .inline)
                    }.tag(3)
                        .tabItem {
                            Image(systemName: "gearshape.circle.fill")
                            Text("Settings")
                        }
                }
            }
            else {
                ZStack(alignment: move){
                    if callManagerPJSIP.isVideoCall{
                        RemoteVideoView(vidWin: $vinfo.vid_win)
                            .onTapGesture {
                                showingSheet.toggle()
                            }
//                        if !showingAlert{
//                            PictureInPictureViewController(videoView: $vinfo.vid_win, pipController: $pipController, pipVideoCallViewController: $pipVideoCallViewController)
//                                .onTapGesture {
//                                    showingSheet.toggle()
//                                }
//                        }
//                        if !showingSheet{
                            DraggableVideoCallView(content: {
                                LocalVideoView(localvidWin: $vinfo.localvid_win)
                                    .frame(width: 150,height: 200)
                            })
//                        }
                    }else{
                        AudioCallView(callNumber: callManagerPJSIP.receiverID)
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    VStack{
                        CallInterfaceView(receivedEndCall: receivedEndCall, hasActivateCall: $callHistoryManager.hasActivateCall, callID: $callHistoryManager.callID, isAnyCallPanding: $callHistoryManager.isAnyCallPanding)
                            .padding(.top,20)
                        PresentVideoView()
                    }
                    .presentationDetents([.height(240),.medium])
                    .presentationDragIndicator(.automatic)
                    //                    .interactiveDismissDisabled()
                    .presentationBackground(Color.black.opacity(0.6))
                }
            }
        }
        .ignoresSafeArea()
        .onAppear{
            callManagerPJSIP.registerPJSIP(userName: registerWithPJSIP.userName, sipDomain: registerWithPJSIP.sipDomain, password: registerWithPJSIP.password, isRegister: true) { isSuccess, message in
                print("Massage: \(message)")
            }
        }
    }
}

//class PictureInPictureViewController: UIViewController, AVPictureInPictureControllerDelegate {
//    
//    private var pipController: AVPictureInPictureController!
//    private var pipVideoCallViewController: AVPictureInPictureVideoCallViewController!
//
//    override func viewDidLoad() {
//        let videoView = RemoteVideoView(vidWin: <#T##Binding<UIView?>#>)
//        let sampleBufferVideoCallView = SampleBufferVideoCallView()
//        sampleBufferVideoCallView.contentMode = .scaleAspectFit
//
//        pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
//        pipVideoCallViewController.preferredContentSize = CGSize(width: 1080, height: 1920)
//        pipVideoCallViewController.view.addSubview(sampleBufferVideoCallView)
//
//        sampleBufferVideoCallView.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = [
//            sampleBufferVideoCallView.leadingAnchor.constraint(equalTo: pipVideoCallViewController.view.leadingAnchor),
//            sampleBufferVideoCallView.trailingAnchor.constraint(equalTo: pipVideoCallViewController.view.trailingAnchor),
//            sampleBufferVideoCallView.topAnchor.constraint(equalTo: pipVideoCallViewController.view.topAnchor),
//            sampleBufferVideoCallView.bottomAnchor.constraint(equalTo: pipVideoCallViewController.view.bottomAnchor)
//        ]
//        NSLayoutConstraint.activate(constraints)
//
//
//        sampleBufferVideoCallView.bounds = pipVideoCallViewController.view.frame
//
//        let pipContentSource = AVPictureInPictureController.ContentSource(
//            activeVideoCallSourceView: videoView,
//            contentViewController: pipVideoCallViewController
//        )
//
//        pipController = AVPictureInPictureController(contentSource: pipContentSource)
//        pipController.canStartPictureInPictureAutomaticallyFromInline = true
//        pipController.delegate = self
//    }
//}
//
//class SampleBufferVideoCallView: UIView {
//    override class var layerClass: AnyClass {
//        AVSampleBufferDisplayLayer.self
//    }
//    
//    var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer {
//        layer as! AVSampleBufferDisplayLayer
//    }
//}
//
