//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

@available(iOS 13.0, *)
struct AvailableStatusView: View {
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
//    @Binding var isOffline:Bool
   
    var body: some View {
        ZStack{
            VStack(spacing: 40) {
                Menu {
                    Button {
                        callManagerPJSIP.state = .connecting
                        callManagerPJSIP.isOffline = false
                        callManagerPJSIP.reRegisterPJSIP {
                            callManagerPJSIP.state = .available
                        }
                    } label: {
                        Text("Available")
                            .foregroundColor(.green)
                        Image(systemName: "arrow.down.right.circle")
                    }
                    Button {
                        callManagerPJSIP.state = .unavailable
                        callManagerPJSIP.isOffline = false
                        callManagerPJSIP.unregisterPJSIP()
                    } label: {
                        Text("Unavailable")
                            .foregroundColor(.red)
                        Image(systemName: "arrow.up.and.down.circle")
                    }
                    
                    Button {
                        callManagerPJSIP.state = .offline
                        callManagerPJSIP.isOffline = true
                        callManagerPJSIP.unregisterPJSIP()
                        
                    } label: {
                        Text("Offline")
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.up.and.down.circle")
                    }
                } label: {
                    Text(callManagerPJSIP.state.rawValue)
                    Image(systemName: "chevron.down")
                }
            }
        }
    }
}

