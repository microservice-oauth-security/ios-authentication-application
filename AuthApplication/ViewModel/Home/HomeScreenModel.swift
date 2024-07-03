//
//  HomeScreenModel.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 02/07/24.
//

import Foundation
class HomeScreenModel: ObservableObject{
    @Published var userName : String?
    @Published var roles : [String]?
    @Published var showProgress = false
}
