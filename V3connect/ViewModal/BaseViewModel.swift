//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
class BaseViewModal: ObservableObject {
    @Published var resultState: ResultState<[Int]> = .failed(error: "")
    @Published var isloading:Bool = false
}
