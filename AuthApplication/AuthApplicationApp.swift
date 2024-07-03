//
//  AuthApplicationApp.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import SwiftUI

@main
struct AuthApplicationApp: App {
    @AppStorage("accessToken") var accessToken = ""
    var body: some Scene {
        WindowGroup {
            if(accessToken == "")
            {
                AuthScreen()
            }else{
                HomeScreen()
            }
        }
    }
}
