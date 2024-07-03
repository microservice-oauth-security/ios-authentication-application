//
//  EmployeeViewModel.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 03/07/24.
//

import Foundation
class EmployeeViewModel : ObservableObject{
    @Published var employees : [EmployeeResponse]?
    @Published var error : String?
}
