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

struct PictureInPictureViewController: UIViewControllerRepresentable {
    @Binding var videoView: UIView?
    @Binding var pipController: AVPictureInPictureController?
    @Binding var pipVideoCallViewController: AVPictureInPictureVideoCallViewController?

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = AVPictureInPictureVideoCallViewController()
        let sampleBufferVideoCallView = SampleBufferVideoCallView()
        sampleBufferVideoCallView.contentMode = .scaleAspectFit
        if var pipVideoCallViewController = pipVideoCallViewController{
            pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
            pipVideoCallViewController.preferredContentSize = CGSize(width: 100, height: 190)
            pipVideoCallViewController.view.addSubview(sampleBufferVideoCallView)
            
            sampleBufferVideoCallView.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                sampleBufferVideoCallView.leadingAnchor.constraint(equalTo: pipVideoCallViewController.view.leadingAnchor),
                sampleBufferVideoCallView.trailingAnchor.constraint(equalTo: pipVideoCallViewController.view.trailingAnchor),
                sampleBufferVideoCallView.topAnchor.constraint(equalTo: pipVideoCallViewController.view.topAnchor),
                sampleBufferVideoCallView.bottomAnchor.constraint(equalTo: pipVideoCallViewController.view.bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            
            
            sampleBufferVideoCallView.bounds = pipVideoCallViewController.view.frame
            
            let remoteVideoView = UIHostingController(rootView: RemoteVideoView(vidWin: $videoView))
            if let remoteView = remoteVideoView.view {
                let pipContentSource = AVPictureInPictureController.ContentSource(
                    activeVideoCallSourceView: remoteView,
                    contentViewController: pipVideoCallViewController
                )
                pipController = AVPictureInPictureController(contentSource: pipContentSource)
                pipController?.canStartPictureInPictureAutomaticallyFromInline = true
            }
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVPlayerViewControllerDelegate {
        let parent: PictureInPictureViewController
        init(_ parent: PictureInPictureViewController) {
            self.parent = parent
        }
    }
}


class SampleBufferVideoCallView: UIView {
    override class var layerClass: AnyClass {
        AVSampleBufferDisplayLayer.self
    }
    
    var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer {
        layer as! AVSampleBufferDisplayLayer
    }
}
