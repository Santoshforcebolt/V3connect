//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation


protocol ApiProvider {
    var voipDeviceTokenApi: VoipDeviceTokenApi { get }
}

class ApiProviderImpl: ApiProvider {
    
    static var instance = ApiProviderImpl()
    
    private init() {}
    
    var voipDeviceTokenApi: VoipDeviceTokenApi {
        return VoipDeviceTokenImpl()
    }
}
