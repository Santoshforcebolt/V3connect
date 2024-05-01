//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

import SwiftUI

struct BaseView<T: BaseViewModal,Content: View>: View {
    @ObservedObject var viewModel: T
    var content: () -> Content
    
    init(viewModel: T, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
    
    var body: some View {
        ZStack{
            content()
            Color.black.opacity(0.5)
            ProgressView()
        }.ignoresSafeArea()  
    }
}
