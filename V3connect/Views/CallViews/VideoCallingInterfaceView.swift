//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI
import AVFoundation



class VideoCaptureManager: ObservableObject {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    init() {
        setupCaptureSession()
    }

    private func setupCaptureSession() {
        // Get the default video capture device
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("Video capture device is unavailable")
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: captureDevice)

            // Add the input to the capture session
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            fatalError("Failed to create AVCaptureDeviceInput: \(error)")
        }

        // Configure other session settings
        captureSession.sessionPreset = .high

        // Start the capture session
        captureSession.startRunning()

        // Set up AVCaptureVideoPreviewLayer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    }
}

struct VideoCallingInterfaceView: View {
    @ObservedObject var videoCaptureManager = VideoCaptureManager()
    var body: some View {
        VStack {
            if let videoPreviewLayer = videoCaptureManager.videoPreviewLayer {
                VideoPreview(videoLayer: videoPreviewLayer)
            }
        }
    }
}

struct VideoPreview: UIViewRepresentable {
    var videoLayer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        videoLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            videoLayer.frame = uiView.layer.bounds
        }
    }
}


