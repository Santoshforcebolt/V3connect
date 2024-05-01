//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//
import CallKit

extension CXCallUpdate {
    func update(with remoteUserID: String, hasVideo: Bool, incoming: Bool) {
        // the other caller is identified by a CXHandle object
        let remoteHandle = CXHandle(type: .generic, value: remoteUserID)
        
        self.remoteHandle = remoteHandle
        self.localizedCallerName = remoteUserID
        self.hasVideo = hasVideo
    }
    
    func onFailed(with uuid: UUID) {
        let remoteHandle = CXHandle(type: .generic, value: "Unknown")
        
        self.remoteHandle = remoteHandle
        self.localizedCallerName = "Unknown"
        self.hasVideo = false
    }
}
