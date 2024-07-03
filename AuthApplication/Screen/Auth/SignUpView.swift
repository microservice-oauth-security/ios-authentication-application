//
//  SignUpView.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authScreenModel : AuthScreenModel
    @ObservedObject var signUpViewModel : SignUpViewModel
    let screenResetHandler : ScreenResetHandler
    var body: some View {
        VStack{
            Group{
                TextField("UserName",
                          text: $signUpViewModel.userName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                .onChange(of: signUpViewModel.userName, perform: { _ in
                    signUpViewModel.userNameError = nil
                })
                Divider()
                if let error = signUpViewModel.userNameError {
                    Text(error).foregroundColor(.red)
                }
            }
            Group{
                SecureField("Password",
                            text: $signUpViewModel.password)
                .padding(.top, 20)
                .onChange(of: signUpViewModel.password, perform: { _ in
                    signUpViewModel.passwordError = nil
                })
                Divider()
                if let error = signUpViewModel.passwordError {
                    Text(error).foregroundColor(.red)
                }
            }
            Group{
                SecureField("Confirm Password",
                            text: $signUpViewModel.confirmPassword)
                .textContentType(.newPassword)
                .padding(.top, 20)
                .onChange(of: signUpViewModel.confirmPassword, perform: { _ in
                    signUpViewModel.confirmPasswordError = nil
                })
                Divider()
                if let error = signUpViewModel.confirmPasswordError {
                    Text(error).foregroundColor(.red)
                }
            }
            Spacer().frame(height: 30)
            Button(action: signUp,
                   label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            Spacer().frame(height: 20)
            HStack{
                Text("Already a Member?")
                Text("Login").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        screenResetHandler.resetView("signup")
                        authScreenModel.isLogin = true
                    }
            }
        }
    }
    
    func signUp()
    {
        if(isInputValid())
        {
            authScreenModel.showProgress = true
            AuthAction().doSignIn(AuthRequest(userName: signUpViewModel.userName, password: signUpViewModel.password)){error , authResponse, errorResponse in
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
        
    }
    
    func isInputValid() -> Bool{
        if(signUpViewModel.userName.isEmpty)
        {
            signUpViewModel.userNameError = "Enter UserName"
            return false
        }else if (signUpViewModel.password.isEmpty)
        {
            signUpViewModel.passwordError = "Enter Password"
            return false
        }else if (signUpViewModel.confirmPassword.isEmpty)
        {
            signUpViewModel.confirmPasswordError = "Confirm the Password"
            return false
        }else if (signUpViewModel.confirmPassword != signUpViewModel.password)
        {
            signUpViewModel.confirmPasswordError = "Password does not match"
            return false
        }
        return true
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authScreenModel: AuthScreenModel(), signUpViewModel: SignUpViewModel(), screenResetHandler: AuthScreen())
    }
}
