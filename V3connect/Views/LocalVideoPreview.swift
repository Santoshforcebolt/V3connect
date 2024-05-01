//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
import SwiftUI
import AVFoundation


//struct LocalVideoView: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView();
//        view.backgroundColor = UIColor.black;
//        return view;
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//            // Perform AVCaptureSession setup on a background thread
//            DispatchQueue.main.async {
//                self.setupAVCaptureSession(uiView)
//            }
//        }
//
//    func setupAVCaptureSession(_ uiView: UIView) {
//            let captureSession = AVCaptureSession()
//            let cameraOutput = AVCaptureVideoDataOutput()
//
//        captureSession.sessionPreset = .low
//
//            guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
//                print("Front camera not available")
//                return
//            }
//
//
//
//            do {
//                let input = try AVCaptureDeviceInput(device: frontCamera)
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                }
//
//                if captureSession.canAddOutput(cameraOutput) {
//                    captureSession.addOutput(cameraOutput)
//                }
//
//                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                videoPreviewLayer.videoGravity = .resizeAspectFill
//
//                captureSession.sessionPreset = .medium // You can adjust the preset as needed
//                videoPreviewLayer.connection?.videoOrientation = .portrait // Adjust orientation if needed
//                if let frameRateRanges = frontCamera.activeFormat.videoSupportedFrameRateRanges.first {
//                    // Choose a frame rate within the supported range (e.g., 30 FPS)
//                    let desiredFrameRate = min(30, frameRateRanges.maxFrameRate)
//
//                    do {
//                        try frontCamera.lockForConfiguration()
//                        frontCamera.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(desiredFrameRate))
//                        frontCamera.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(desiredFrameRate))
//                        frontCamera.unlockForConfiguration()
//                    } catch {
//                        print("Error setting frame rate: \(error.localizedDescription)")
//                    }
//                } else {
//                    print("No supported frame rate ranges found for the camera.")
//                }
//                // Perform UI updates related to AVCaptureSession on the main thread
//                DispatchQueue.main.async {
//                    videoPreviewLayer.frame = uiView.layer.bounds
//                    uiView.layer.addSublayer(videoPreviewLayer)
//                }
//
//                captureSession.startRunning()
//            } catch {
//                print("Error setting up capture session: \(error.localizedDescription)")
//            }
//
//
//    }
//}


//class PreviewView: UIView {
//    private var captureSession: AVCaptureSession?
//
//    init() {
//        super.init(frame: .zero)
//
//        var allowedAccess = false
//        let blocker = DispatchGroup()
//        blocker.enter()
//        AVCaptureDevice.requestAccess(for: .video) { flag in
//            allowedAccess = flag
//            blocker.leave()
//        }
//        blocker.wait()
//
//        if !allowedAccess {
//            print("!!! NO ACCESS TO CAMERA")
//            return
//        }
//
//        // setup session
//        let session = AVCaptureSession()
//        session.beginConfiguration()
//
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//            for: .video, position: .unspecified) //alternate AVCaptureDevice.default(for: .video)
//        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
//            print("!!! NO CAMERA DETECTED")
//            return
//        }
//        session.addInput(videoDeviceInput)
//        session.commitConfiguration()
//        self.captureSession = session
//    }
//
//    override class var layerClass: AnyClass {
//        AVCaptureVideoPreviewLayer.self
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//        return layer as! AVCaptureVideoPreviewLayer
//    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//
//        if nil != self.superview {
//            self.videoPreviewLayer.session = self.captureSession
//            self.videoPreviewLayer.videoGravity = .resizeAspect
//            self.captureSession?.startRunning()
//        } else {
//            self.captureSession?.stopRunning()
//        }
//    }
//}
//
//struct LocalVideoView: UIViewRepresentable {
//    func makeUIView(context: UIViewRepresentableContext<LocalVideoView>) -> PreviewView {
//        PreviewView()
//    }
//
//    func updateUIView(_ uiView: PreviewView, context: UIViewRepresentableContext<LocalVideoView>) {
//    }
//
//    typealias UIViewType = PreviewView
//}
//
////struct DemoVideoStreaming: View {
////    var body: some View {
////        VStack {
////            PreviewHolder()
////        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
////    }
////}
