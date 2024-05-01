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

class Api {
    var networkManager: AlamoNetworkManager
    
    init(networkManager: AlamoNetworkManager = AlamoNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func buildHeaders(additionalHeaders: [String: String]?) -> Alamofire.HTTPHeaders {
        var headers: [String:String] = [:]
        headers["cache-control"] = "no-cache"
        headers["Accept-Encoding"] = "gzip"
        headers["version_code"] = "25"
        headers["client_type"] = "ios"
        
        var alamoFireHeaders = Alamofire.HTTPHeaders(headers)
        
        if let additionalHeaders = additionalHeaders {
            for header in additionalHeaders {
                alamoFireHeaders.add(name: header.key, value: header.value)
            }
        }
        return alamoFireHeaders
    }
    
}
