//
//  EmployeeView.swift
//  AuthApplication
//
//  Created by Anish Kumar SS on 03/07/24.
//

import SwiftUI

struct EmployeeView: View {
    @ObservedObject var employeeViewModel : EmployeeViewModel
    @ObservedObject var homeScreenModel : HomeScreenModel
    static let logoutDelay = 5
    var body: some View {
        VStack{
            Button(action: fetchEmployees, label : {
                Text("Fetch Employees")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            if let employees = employeeViewModel.employees{
                
                Spacer().frame(height: 30)
                
                ForEach(employees.indices, id: \.self) { idx in
                    if(idx == 0)
                    {
                        HStack{
                            Text("Name").bold().frame(minWidth:0, maxWidth: .infinity).lineLimit(1)
                            Spacer()
                            Text("Company").bold().frame(minWidth:0, maxWidth: .infinity).lineLimit(1)
                            Spacer()
                            Text("Designation").bold().frame(minWidth:0, maxWidth: .infinity).lineLimit(1)
                        }
                        Divider()
                    }
                    
                    HStack{
                        Text(employees[idx].name).font(.system(size: 12)).frame(minWidth:0, maxWidth: .infinity).lineLimit(1)
                        Spacer()
                        Text(employees[idx].company).font(.system(size: 12)).frame(minWidth:0, maxWidth: .infinity).lineLimit(1)
                        Spacer()
                        Text(employees[idx].designation).font(.system(size: 12)).frame(minWidth:0, maxWidth: .infinity).lineLimit(1)
                    }
                 }
            }
            
            if let error = employeeViewModel.error{
                Spacer().frame(height: 20)
                Text(error).foregroundColor(.red)
            }
        }
    }
    
    func fetchEmployees(){
        reset()
        homeScreenModel.showProgress = true
        EmployeeAction().fetchEmployees(){error, employeeResponseArray, apiError in
            DispatchQueue.main.async {
                homeScreenModel.showProgress = false
                if let error = error{
                    employeeViewModel.error = error
                }else if let apiError = apiError{
                    if(apiError.httpStatusCode == 401)
                    {
                        Task {
                            await delayAndLogout()
                        }
                    }else if(apiError.httpStatusCode == 403)
                    {
                        employeeViewModel.error = "You don't have permission to access this service"
                    }else{
                        employeeViewModel.error = apiError.errorMessage
                    }
                }else if let employeeResponseArray = employeeResponseArray{
                    employeeViewModel.employees = employeeResponseArray
                }
            }
        }
        
        func reset(){
            employeeViewModel.error = nil
            employeeViewModel.employees = nil
        }
    }
    
    private func delayAndLogout() async{
        //(1 second = 1_000_000_000 nanoseconds)
        for i in 1...EmployeeView.logoutDelay{
            DispatchQueue.main.async{
                employeeViewModel.error = "Your Authorization Expired!!! You will be logged out in \(EmployeeView.logoutDelay + 1 - i) seconds..."
            }
            try? await Task.sleep(nanoseconds: 1_000_000_000 )
        }
        DispatchQueue.main.async{
            UserDefaults.standard.set("", forKey: "accessToken")
        }
    }
}

struct EmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeView(employeeViewModel: EmployeeViewModel(), homeScreenModel: HomeScreenModel())
    }
}
