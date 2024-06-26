//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import UIKit
import CallKit

extension CXProviderConfiguration {
    
    static var custom: CXProviderConfiguration {
        let configuration = CXProviderConfiguration(localizedName: "V3Connect")
        
        // Native call log shows video icon if it was video call.
        configuration.supportsVideo = true
        configuration.maximumCallsPerCallGroup = 1
        
        // Support generic type to handle *User ID*
        configuration.supportedHandleTypes = [.generic]
        
        // Icon image forwarding to app in CallKit View
        if let iconImage = UIImage(named: "App Icon") {
            configuration.iconTemplateImageData = iconImage.pngData()
        }
        
        // Ringing sound
        configuration.ringtoneSound = "Rington.mp3"
        
        return configuration
    }
}
