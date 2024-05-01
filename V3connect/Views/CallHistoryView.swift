//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

struct CallHistoryView: View {
    
    @EnvironmentObject var callHistoryManager: CallHistoryManager
    @StateObject var receivedEndCall = ReceivedEndCall()
    @State private var searchText = ""
    @State var showToast: Bool = false
    @State var errorMessage: String = ""
    @State private var filteredCallHistory: [CallEntry] = []
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, h:mm a"
        if Calendar.current.isDateInToday(Date()) {
            formatter.dateFormat = formatter.dateFormat
        }
        return formatter
    }
    
    var body: some View {
        VStack {
            if(filteredCallHistory.isEmpty){
                Text("No Any call")
                    .bold()
            }else{
                SearchBar(text: $searchText)
                List{
                    ForEach(filteredCallHistory, id: \.id){ call in
                        HStack{
                            VStack(alignment: .leading) {
                                Text(call.name)
                                    .font(.headline)
                                Text(dateFormatter.string(from: call.callTime))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            HStack(spacing: 20){
                                OutgoingInterfaceView(receiverID: .constant(call.name) , hasActivateCall: $callHistoryManager.hasActivateCall, callID: $callHistoryManager.callID, isAnyCallPanding: $callHistoryManager.isAnyCallPanding, lastRecentCallID: .constant(call.name), hasVideo: true, receivedEndCall: receivedEndCall)
                                
                                OutgoingInterfaceView(receiverID: .constant(call.name) , hasActivateCall: $callHistoryManager.hasActivateCall, callID: $callHistoryManager.callID, isAnyCallPanding: $callHistoryManager.isAnyCallPanding, lastRecentCallID: .constant(call.name), hasVideo: false, receivedEndCall: receivedEndCall)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        delete(at: indexSet)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }.onChange(of: searchText, perform: { newValue in
            updateFilteredCallHistory()
        })
        .onAppear {
            updateFilteredCallHistory()
        }
    }
    private func delete(at offsets: IndexSet) {
        callHistoryManager.deleteEntries(at: offsets)
        filteredCallHistory = callHistoryManager.getCallHistory()
    }
    
    private func updateFilteredCallHistory() {
        if searchText.isEmpty {
            filteredCallHistory = callHistoryManager.getCallHistory()
        } else {
            filteredCallHistory = callHistoryManager.getCallHistory().filter { call in
                call.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $text)
            }.padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(.systemGray5))
                )
        }
        .padding(.horizontal)
    }
}


struct CallHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        CallHistoryView()
    }
}
