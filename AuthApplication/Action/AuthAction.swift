//
//  AuthAction.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import Foundation
struct AuthAction{
    
    let baseUrl = Bundle.main.infoDictionary?["AUTH_URL"] as? String
    
    func doLogin(_ authRequest: AuthRequest, completionHandler: @escaping (String?, AuthResponse?, ErrorResponse?) -> Void){
        
        if let request = try? createAuthUrlRequest(authRequest, "/login") {
            executeAuthTask(request){ error, authResponse, errorResponse in
                completionHandler(error, authResponse, errorResponse)
            }
        }else{
            completionHandler("Invalid request", nil, nil)
        }
    }
    
    
    func doSignIn(_ authRequest: AuthRequest, completionHandler: @escaping (String?, AuthResponse?, ErrorResponse?) -> Void){
        if let request = try? createAuthUrlRequest(authRequest, "/sign-in") {
            executeAuthTask(request){ error, authResponse, errorResponse in
                completionHandler(error, authResponse, errorResponse)
            }
        }else{
            completionHandler("Invalid request", nil, nil)
        }
    }
    
    func do3pSignIn(_ authRequest : ThirdPartyAuthRequest, _ idToken : String, completionHandler : @escaping (String?, AuthResponse?, ErrorResponse?) -> Void)
    {
        if let request = try? create3pAuthRequest(authRequest, idToken, "/3p/sign-in"){
            executeAuthTask(request){error, authResponse, errorResponse in
                completionHandler(error, authResponse, errorResponse)
            }
        }else{
            completionHandler("Invalid request", nil, nil)
        }
    }
    
    private func createAuthUrlRequest(_ authRequest: AuthRequest, _ path : String) throws -> URLRequest? {
        guard let url = URL(string: baseUrl! + path) else{
            return nil
        }
        var urlRequest  = URLRequest(url: url)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(authRequest)
        return urlRequest
    }
    
    private func create3pAuthRequest(_ authRequest : ThirdPartyAuthRequest, _ idToken : String , _ path : String) throws -> URLRequest? {
        guard let url = URL(string: baseUrl! + path) else{
            return nil
        }
        var urlRequest = URLRequest(url : url)
        urlRequest.httpMethod = "post"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer "+idToken, forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try JSONEncoder().encode(authRequest)
        return urlRequest
    }
    
    private func executeAuthTask(_ urlRequest : URLRequest, completionHandler: @escaping (String?, AuthResponse?, ErrorResponse?) -> Void){
        let dataTask = URLSession.shared.dataTask(with: urlRequest){data,response,error in
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse{
                    if 200...299 ~= httpResponse.statusCode {
                        if let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data){
                            completionHandler(nil, authResponse, nil)
                        }else{
                            completionHandler("Oops!!! Something went wrong", nil, nil)
                        }
                    }else{
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data){
                            completionHandler(nil, nil, errorResponse)
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
