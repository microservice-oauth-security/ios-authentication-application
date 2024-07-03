//
//  AuthScreen.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import SwiftUI

struct AuthScreen: View, ScreenResetHandler {
    @ObservedObject var authScreenModel = AuthScreenModel()
    @ObservedObject var loginViewModel =  LoginViewModel()
    @ObservedObject var signUpViewModel =  SignUpViewModel()
    var body: some View {
        ScrollView{
            ZStack{
                VStack{
                    Spacer().frame(height: 50)
                    GoogleSignInView(authScreenModel: authScreenModel, screenResetHandler: self)
                    Spacer().frame(height: 20)
                    HStack{
                        VStack{Divider()}
                        Text("or")
                        VStack{Divider()}
                    }
                    if(authScreenModel.isLogin)
                    {
                        LoginView(authScreenModel: authScreenModel, loginViewModel: loginViewModel, screenResetHandler: self)
                    }else{
                        SignUpView(authScreenModel: authScreenModel, signUpViewModel: signUpViewModel, screenResetHandler: self)
                    }
                    Spacer().frame(height: 20)
                    if let error = authScreenModel.error{
                        Text(error).foregroundColor(.red)
                    }
                }.padding()
                if(authScreenModel.showProgress)
                {
                    ProgressView().scaleEffect(2)
                }
            }
        }
    }
    
    func resetView(_ viewName: String) {
        if(viewName == "login")
        {
            resetLoginView()
        }else if ( viewName == "signup"){
            resetSignUpView()
        }else if(viewName == "all")
        {
            resetLoginView()
            resetSignUpView()
        }
    }
    
    func resetLoginView()
    {
        authScreenModel.error = nil
        loginViewModel.userName = ""
        loginViewModel.password = ""
        loginViewModel.userNameError = nil
        loginViewModel.passwordError = nil
    }
    
    func resetSignUpView()
    {
        authScreenModel.error = nil
        signUpViewModel.userName = ""
        signUpViewModel.password = ""
        signUpViewModel.confirmPassword = ""
        signUpViewModel.userNameError = nil
        signUpViewModel.passwordError = nil
        signUpViewModel.confirmPasswordError = nil
    }
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen()
    }
}
