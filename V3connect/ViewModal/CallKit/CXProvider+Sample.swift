//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

import CallKit

extension CXProvider {
    // To ensure initializing only at once. Lazy stored property doesn't ensure it.
    static var custom: CXProvider {
        
        // Configure provider with sendbird's customzied configuration.
        let configuration = CXProviderConfiguration.custom
        let provider = CXProvider(configuration: configuration)
        
        return provider
    }
}
