//
//  HomeScreen.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 01/07/24.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage("accessToken") var accessToken = ""
    @ObservedObject var homeScreenModel = HomeScreenModel()
    @ObservedObject var employeeViewModel = EmployeeViewModel()
    var body: some View {
        ScrollView{
            ZStack{
                VStack{
                    HStack{
                        Text("Welcome \(homeScreenModel.userName ?? "")")
                        Spacer()
                        Button(action: {}, label:{
                            Text("Logout")
                                .frame(minWidth : 100, minHeight: 50)
                                .foregroundColor(.red)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black))
                                .cornerRadius(10)
                        })
                    }
                    Divider()
                    
                    if let roles = homeScreenModel.roles{
                        HStack{
                            Text("Your Roles").bold()
                            Spacer()
                        }
                        ForEach(roles, id : \.self){ role in
                            HStack{
                                Text(role).font(.system(size: 14))
                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer().frame(height: 50)
                    EmployeeView(employeeViewModel: employeeViewModel, homeScreenModel: homeScreenModel)
                    
                }.padding()
                    .onAppear(perform :{
                        loadUserAttributes()
                    })
                if(homeScreenModel.showProgress)
                {
                    ProgressView().scaleEffect(2)
                }
            }
        }
    }
    
    func logout()
    {
        UserDefaults.standard.set("", forKey: "accessToken")
    }
    
    func loadUserAttributes()
    {
        guard let userClaim = getUserClaim() else {
            return
        }
        homeScreenModel.userName =  userClaim.userName
        homeScreenModel.roles = userClaim.authorities
    }
    
    func getUserClaim() -> UserClaim?{
        var base64 : String = String(accessToken.split(separator: ".")[1])
        // need to pad this base64 value, as Data(base64Encoded:) returns nil if it is missing
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length/4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0{
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        // padding finished
        if let decodedToken = Data(base64Encoded: base64, options: .ignoreUnknownCharacters){
            if let userClaim = try? JSONDecoder().decode(UserClaim.self, from: decodedToken){
                return userClaim
            }
        }
        return nil
    }
 
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
