//
//  SignUpViewModel.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import Foundation
class SignUpViewModel: ObservableObject{
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var userNameError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
}
