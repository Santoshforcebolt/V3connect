//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI


struct SettingViewLoader: View{
    @ObservedObject var baseVM = BaseViewModal()
    @ObservedObject var registerWithPJSIP: RegisterWithPJSIP
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
    @Binding var isOffline: Bool
    
    var body: some View{
        ZStack{
            VStack{
                SettingView(baseVM: baseVM, registerWithPJSIP: registerWithPJSIP, isOffline: $isOffline)
            }
        }
    }
}

struct SettingView: View {
    @ObservedObject var baseVM: BaseViewModal
    @EnvironmentObject var callmanagerPJSIP: CallManagerPJSIP
    @ObservedObject var registerWithPJSIP : RegisterWithPJSIP
    @Binding var isOffline: Bool
    @State var showAlert = false
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.green)
                    .clipShape(Circle())
                
                VStack(alignment: .leading,spacing: 5){
                    Text("\(registerWithPJSIP.userName)@\(registerWithPJSIP.sipDomain)")
                        .font(.title)
                    AvailableStatusView()
                }
                Spacer()
            }.padding(.horizontal)
            List{
                ForEach(settingsData,id:\.self){ index in
                    Button {
                        actionSettings(type: index.detailName)
                    } label: {
                        HStack{
                            Image(systemName: index.imageName)
                            VStack(alignment: .leading) {
                                Text(index.detailName.rawValue)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }.listStyle(PlainListStyle())
        } .alert("Logout", isPresented: $showAlert) {
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Are you sure you want to Logout")
        }
    }
    
    func actionSettings(type: SettingsEnum){
        switch(type){
        case .logout:
            showAlert = true
            break
        default:
            break
        }
    }
    
    func logout(){
        callmanagerPJSIP.logout {
            print("Successfully logout")
        }
        registerWithPJSIP.userName = ""
        registerWithPJSIP.sipDomain = ""
        registerWithPJSIP.password = ""
        registerWithPJSIP.isRegistered = false
        pjsipInitialized = 0
        CallHistoryManager.shared.deleteAllEntries()
    }
}
