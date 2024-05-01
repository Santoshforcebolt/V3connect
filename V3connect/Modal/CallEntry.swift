//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation

struct CallEntry: Codable {
    var id = UUID()
    let name: String
    let callTime: Date 
}
