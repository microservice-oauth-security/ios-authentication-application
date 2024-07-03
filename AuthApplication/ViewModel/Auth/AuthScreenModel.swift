//
//  AuthScreenModel.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import Foundation
class AuthScreenModel: ObservableObject{
    @Published var isLogin = true
    @Published var error: String?
    @Published var showProgress = false
}
