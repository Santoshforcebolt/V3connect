//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation

class CallHistoryManager: ObservableObject {
    private var callEntries: [CallEntry] = []
    @Published var isAnyCallPanding: Bool = false
    @Published var callID: UUID? = nil
    @Published var receiverID: String = ""
    @Published var hasActivateCall: Bool = false
    static let shared = CallHistoryManager() 
    init() {
        loadCallHistory()
    }

    func addCall(name: String, callTime: Date) {
        let call = CallEntry(name: name, callTime: callTime)
        callEntries.append(call)
        trimCallHistory()
        saveCallHistory()
    }

    func getCallHistory() -> [CallEntry] {
        return callEntries.reversed()
    }

    private func trimCallHistory() {
        while callEntries.count > 20 {
            callEntries.removeFirst()
        }
    }
    
    func deleteEntries(at index: IndexSet){
        callEntries.remove(atOffsets: index)
        saveCallHistory()
    }
    
    func deleteAllEntries(){
        callEntries.removeAll()
        saveCallHistory()
    }

    private func saveCallHistory() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(callEntries) {
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("callHistory.json")
            do {
                try encodedData.write(to: fileURL)
            } catch {
                print("Error saving call history: \(error)")
            }
        }
    }

    private func loadCallHistory() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("callHistory.json")
        if let data = try? Data(contentsOf: fileURL) {
            let decoder = JSONDecoder()
            if let loadedCallEntries = try? decoder.decode([CallEntry].self, from: data) {
                callEntries = loadedCallEntries
            }
        }
    }
}

