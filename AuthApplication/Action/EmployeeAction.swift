//
//  EmployeeAction.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 03/07/24.
//

import Foundation
import SwiftUI
struct EmployeeAction
{
    @AppStorage("accessToken") var accessToken = ""
    let baseUrl = Bundle.main.infoDictionary?["DEMO_SERVICE_URL"] as? String
    
    func fetchEmployees(completionHandler : @escaping (String?, [EmployeeResponse]?, ApiError?) -> Void){
        guard let url = URL(string: baseUrl! + "/employee")else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data, response, error in
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse{
                    if 200...299 ~= httpResponse.statusCode {
                        if let employeeResponseArray = try? JSONDecoder().decode([EmployeeResponse].self, from: data){
                            completionHandler(nil, employeeResponseArray, nil)
                        }else{
                            completionHandler("Oops!!! Something went wrong", nil, nil)
                        }
                    }else if(httpResponse.statusCode == 401 || httpResponse.statusCode == 403){
                        completionHandler(nil, nil, ApiError(httpStatusCode:httpResponse.statusCode,errorMessage: ""))
                    }
                    else{
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                            completionHandler(nil, nil, ApiError(httpStatusCode:httpResponse.statusCode,errorMessage: errorResponse.errorMessage))
                        }else{
                            completionHandler("Oops!!! Something went wrong", nil, nil)
                        }
                    }
                }
            }else{
                if let error = error{
                    completionHandler(error.localizedDescription, nil, nil)
                }
            }
        }
        dataTask.resume()
    }
    
}
