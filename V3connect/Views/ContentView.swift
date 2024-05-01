//
//  ContentView.swift
//
//  Created by Jaesung Lee on 2020/04/24.
//  Copyright © 2020 SweetLab. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // Access `CallManager.shared` singleton
    @EnvironmentObject var callManager: CallManager
    
    var body: some View {
//        DialView()
        Text("")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
