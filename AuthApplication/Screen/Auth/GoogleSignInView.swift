//
//  GoogleSignInView.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct GoogleSignInView: View {
    @ObservedObject var authScreenModel : AuthScreenModel
    let screenResetHandler : ScreenResetHandler
    var body: some View {
        GoogleSignInButton(style : GoogleSignInButtonStyle.wide, action: googleSignIn)
    }
    
    func googleSignIn(){
        screenResetHandler.resetView("all")
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController){result, error in
            if let error = error{
                authScreenModel.error = error.localizedDescription
            }else if let result = result{
                if let idToken = result.user.idToken{
                    authScreenModel.showProgress = true
                    AuthAction().do3pSignIn(ThirdPartyAuthRequest(provider: "GOOGLE"), idToken.tokenString){error, authResponse, errorResponse  in
                        DispatchQueue.main.async{
                            authScreenModel.showProgress = false
                            if let error = error{
                                authScreenModel.error = error
                            }else if let errorResponse = errorResponse {
                                authScreenModel.error = errorResponse.errorMessage
                            }else if let authResponse  = authResponse {
                                UserDefaults.standard.set(authResponse.accessToken, forKey: "accessToken")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct GoogleSignInView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInView(authScreenModel: AuthScreenModel(), screenResetHandler: AuthScreen())
    }
}
