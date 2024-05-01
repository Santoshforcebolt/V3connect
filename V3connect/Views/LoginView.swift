//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import SwiftUI

struct LoginView: View {
    @ObservedObject var baseVM: BaseViewModal
    @ObservedObject var registerWithPJSIP: RegisterWithPJSIP
    @Binding var showingAlert: Bool
    @Binding var statusMessage: String
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                Spacer()
                VStack{
                    Image("Version3")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Spacer()
                .background()
                .dismissKeyboardOnTap()
                VStack{
                    ForEach(loginData, id: \.self){ data in
                        VStack(spacing: 20){
                            TextFieldView(textFieldName: data.detailName, textFieldImageName: data.imageName, userFilledData: data.bindValue)
                        }
                    }
                    Button {
                        if NetworkMonitor.shared.isReachable{
                            baseVM.resultState = .loading
                            registerWithPJSIP.register(handle: { isSuccess, message in
                                if !isSuccess{
                                    baseVM.resultState = .failed(error: message)
                                    statusMessage = message
                                    showingAlert = true
                                    registerWithPJSIP.password = ""
                                }else{
                                    registerWithPJSIP.isRegistered = isSuccess
                                    baseVM.resultState = .success(content: [])
                                }
                            })
                        }else{
                            statusMessage = NetworkMonitor.shared.message
                            showingAlert = true
                        }
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.blue)
                            ).padding()
                    }
                }
                    Spacer()
            }
        }
    }
}


struct TextFieldView: View{
    let textFieldName: String
    let textFieldImageName: String
    @FocusState var focus1: Bool
    @FocusState var focus2: Bool
    @Binding var userFilledData: String
    @State private var isSecured: Bool = false
    var body: some View{
        HStack {
            Image(systemName: textFieldImageName).foregroundColor(.gray)
            if(textFieldName == "Password"){
                ZStack(alignment: .trailing) {
                           TextField("Password", text: $userFilledData)
                               .textContentType(.password)
                               .focused($focus1)
                               .opacity(isSecured ? 1 : 0)
                           SecureField("Password", text: $userFilledData)
                               .textContentType(.password)
                               .focused($focus2)
                               .opacity(isSecured ? 0 : 1)
                           Button(action: {
                               isSecured.toggle()
                               if isSecured { focus1 = true } else { focus2 = true }
                           }, label: {
                               Image(systemName: self.isSecured ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 16, weight: .regular))
                           })
                       }
            }else{
                TextField(textFieldName, text: $userFilledData)
                    .font(.body)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable) // This avoids suggestions bar on the keyboard.
                    .autocorrectionDisabled(true)
            }
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray, lineWidth: 1))
        .padding(.horizontal)
    }
}


