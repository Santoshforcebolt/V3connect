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


struct DraggableVideoCallView<Content: View>: View {
    @State private var pogPosition = CGPoint()
    @State private var size = CGSize.zero
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        GeometryReader { gp in
            content
                .background(GeometryReader {
                    Color.clear
                        .preference(key: ViewSizeKey.self, value: $0.frame(in: .local).size)
                })
                .onPreferenceChange(ViewSizeKey.self) {
                    self.size = $0
                }
                .position(pogPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let insetHeightAmount = 30.0
                            let insetWidthAmount = 30.0
                            let rect = (gp.frame(in: .local))
                                .inset(by: UIEdgeInsets(top: insetHeightAmount, left: insetWidthAmount, bottom: insetHeightAmount, right: insetWidthAmount))
                            print("rect",rect)
                            
                            if rect.contains(value.location) {
                                self.pogPosition = value.location
                            }
                        }
                        .onEnded { value in
                            print(value.location)
                        }
                )
                .onAppear {
                    let rect = gp.frame(in: .local)
                    self.pogPosition = CGPoint(x: rect.minX + 100, y: rect.minY + 130)
                }
        }.edgesIgnoringSafeArea(.all)
    }
}


struct ViewSizeKey: PreferenceKey {
    static var defaultValue = CGSize.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
