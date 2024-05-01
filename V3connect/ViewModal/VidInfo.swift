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

class VidInfo: ObservableObject {
    /* Video window */
    static let shared = VidInfo()
    @Published var vid_win: UIView? = UIView()
    @Published var localvid_win: UIView? = UIView()
}

