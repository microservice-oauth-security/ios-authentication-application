//
//  LoginViewModel.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import Foundation
class LoginViewModel : ObservableObject{
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var userNameError: String?
    @Published var passwordError: String?
}
