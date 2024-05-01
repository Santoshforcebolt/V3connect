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

struct LoginModel: Hashable {
    let id = UUID()
    let imageName: String
    let detailName: String
    let bindValue: Binding<String>
    
    // Provide a hash value for LoginModel
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Implement Equatable to compare LoginModel instances
    static func == (lhs: LoginModel, rhs: LoginModel) -> Bool {
        return lhs.id == rhs.id
    }
}
let regPJSIP = RegisterWithPJSIP.shared
let loginData: [LoginModel] = [
    LoginModel(imageName: "person", detailName: "User Name", bindValue: regPJSIP.$userName),
    LoginModel(imageName: "speedometer", detailName: "Sip Domain", bindValue:  regPJSIP.$sipDomain),
    LoginModel(imageName: "touchid", detailName: "Password", bindValue:  regPJSIP.$password)
]


