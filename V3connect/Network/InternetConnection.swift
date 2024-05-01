//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
import Network


class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    var message: String = ""

    func startMonitoring(){
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                self?.message = "Make sure your device has an Internet connection and try again."
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
