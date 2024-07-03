//
//  LoginView.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authScreenModel : AuthScreenModel
    @ObservedObject var loginViewModel : LoginViewModel
    let screenResetHandler : ScreenResetHandler
    var body: some View {
        VStack{
            TextField("UserName", text : $loginViewModel.userName)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .disableAutocorrection(true)
                .padding(.top, 20)
                .onChange(of: loginViewModel.userName, perform: { _ in
                    loginViewModel.userNameError = nil
                })
            Divider()
            if let error = loginViewModel.userNameError{
                Text(error).foregroundColor(.red)
            }
            SecureField("Password", text : $loginViewModel.password)
                .padding(.top, 20)
                .onChange(of: loginViewModel.password, perform: { _ in
                    loginViewModel.passwordError = nil
                })
            Divider()
            if let error = loginViewModel.passwordError{
                Text(error).foregroundColor(.red)
            }
            Spacer().frame(height : 30)
            Button(action: login, label: {
                Text("Login")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            Spacer().frame(height: 20)
            HStack{
                Text("Not a Member?")
                Text("Sign Up").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        screenResetHandler.resetView("login")
                        authScreenModel.isLogin = false
                    }
            }
        }
    }
    
    func login(){
        if(isInputValid())
        {
            authScreenModel.showProgress = true
            AuthAction().doLogin(AuthRequest(userName: loginViewModel.userName, password: loginViewModel.password)){error , authResponse, errorResponse in
                DispatchQueue.main.async {
                authScreenModel.showProgress = false
                if let error = error{
                    authScreenModel.error = error
                }else if let authResponse = authResponse{
                    UserDefaults.standard.set(authResponse.accessToken, forKey: "accessToken")
                }else if let errorResponse = errorResponse{
                    authScreenModel.error = errorResponse.errorMessage
                }
            }
            }
        }
        
        func isInputValid() -> Bool{
            if(loginViewModel.userName.isEmpty)
            {
                loginViewModel.userNameError = "Enter UserName"
                return false
            }else if (loginViewModel.password.isEmpty)
            {
                loginViewModel.passwordError = "Enter Password"
                return false
            }
            return true
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(authScreenModel : AuthScreenModel(), loginViewModel: LoginViewModel(), screenResetHandler: AuthScreen())
        }
    }
}
