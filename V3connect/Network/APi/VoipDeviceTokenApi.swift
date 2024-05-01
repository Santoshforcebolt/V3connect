//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
import Alamofire

protocol VoipDeviceTokenApi {
    func voipDeviceToken(params: [String: Any],
                      completion: @escaping (VOIPResponse?, AFError?)-> Void)
}

class VoipDeviceTokenImpl: Api, VoipDeviceTokenApi {
    func voipDeviceToken(params: [String: Any],
                      completion: @escaping (VOIPResponse?, AFError?)-> Void) {
        let voipDeviceTokenURL = "https://108.144.214.169:9999/iphone"

        let headers = self.buildHeaders(additionalHeaders: nil)
        self.networkManager.request(urlString: voipDeviceTokenURL,
                                    method: .post,
                                    parameters: params,
                                    headers: headers,
                                    encoding: JSONEncoding.default,
                                    completion: completion)
    }
}

struct VOIPResponse:Codable {
    let validate: String
}
