//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

struct ContentView: View {
    @ObservedObject var baseVM = BaseViewModal()
    @ObservedObject var registerWithPJSIP: RegisterWithPJSIP
    @EnvironmentObject var callManagerPJSIP: CallManagerPJSIP
    @State var showingAlert = false
    @State var statusMessage = ""
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    switch baseVM.resultState {
                    case .loading:
                        BaseView(viewModel: baseVM) {
                            LoginView(baseVM: baseVM, registerWithPJSIP: registerWithPJSIP, showingAlert: $showingAlert, statusMessage: $statusMessage)
                        }
                    case .failed(_):
                        LoginView(baseVM: baseVM, registerWithPJSIP: registerWithPJSIP, showingAlert: $showingAlert, statusMessage: $statusMessage)
                    case .success(_):
                        TabBarView(registerWithPJSIP: registerWithPJSIP)
                    }
                }.alert(statusMessage, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        } .onAppear{
            freeVariable()
            baseVM.resultState = .failed(error: "")
        }
    }
    func freeVariable(){
        registerWithPJSIP.userName = ""
        registerWithPJSIP.sipDomain = ""
        registerWithPJSIP.password = ""
        registerWithPJSIP.isRegistered = false
    }
}

