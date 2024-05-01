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

struct RemoteVideoView: UIViewRepresentable {
    @Binding var vidWin: UIView?
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        let label = UILabel()
        label.text = "Waiting for remote video..."
        label.font = UIFont.boldSystemFont(ofSize: 20)

        // Add the video window
        if let vid_win = vidWin {
            containerView.addSubview(vid_win)
            vid_win.frame = containerView.bounds
        }

        // Add the label
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        return containerView
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        if let vid_win = vidWin {
            /* Add the video window as subview */
            if (!vid_win.isDescendant(of: uiView)) {
                uiView.addSubview(vid_win)
                /* Resize it to fit width */
                vid_win.frame = uiView.bounds
            }
        }
    }
}

struct LocalVideoView: UIViewRepresentable {
    @Binding var localvidWin: UIView?
    func makeUIView(context: Context) -> UIView {
        localvidWin?.backgroundColor = UIColor.clear;
        return localvidWin ?? UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        if let vid_win = localvidWin {
            /* Add the video window as subview */
            if (!vid_win.isDescendant(of: uiView)) {
                uiView.addSubview(vid_win)
                /* Resize it to fit width */
                vid_win.bounds = CGRect(x:0, y:0, width:uiView.bounds.size.width,
                                        height:uiView.bounds.size.height);
                /* Center it horizontally */
                vid_win.center = CGPoint(x:uiView.bounds.size.width / 2.0,
                                         y:vid_win.bounds.size.height / 2.0);
            }
        }
    }
}

struct AudioCallView: View {
    let callNumber: String
    var body: some View {
        VStack(spacing: 50){
            Text(callNumber)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100,height: 100)
            
        }
    }
}



