//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation

enum ResultState<T>{
    case loading
    case failed(error: String)
    case success(content: T)
}
