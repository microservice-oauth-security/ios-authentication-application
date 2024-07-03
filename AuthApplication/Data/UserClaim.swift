//
//  UserClaim.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 03/07/24.
//

import Foundation
struct UserClaim : Codable{
    let userName : String
    let authorities : [String]
    let exp : Int64
    
    private enum CodingKeys : String, CodingKey{
        case userName = "user-name"
        case authorities = "authorities"
        case exp = "exp"
    }
}
