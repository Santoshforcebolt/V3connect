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

@objc
class VideoCallViewController: UIViewController {
    let registerWithPJSIP = RegisterWithPJSIP.shared
    @objc func makeShipDetailsUI(_ name: String) -> UIViewController {
        let details = DialView(registerWithPJSIP: registerWithPJSIP)
        return UIHostingController(rootView: details)
    }
}

//struct VideoCallView: View {
//    var shipName = ""
//    var body: some View {
//        // Your SwiftUI view content for the video call
//        Text("Video Call Content")
//    }
//}
