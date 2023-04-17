//
//  SignUpViewModel.swift
//  Petbook
//
//  Created by user233432 on 3/30/23.
//

import Foundation
class SignUpViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    var fullname: String = ""
    
    
    let serverUrl = "http://172.17.3.211:9090/user/signup"
     
    func signUp(fullname: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         
         let parameters = ["username": fullname,"email": email,"password": password]
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
         
         let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             
             guard let data = data else {
                 completion(.failure(NSError(domain: "No data returned from server", code: 0, userInfo: nil)))
                 return
             }
             
             do {
                 print(data)
                 let decoder = JSONDecoder()
                 let signUpResponse = try decoder.decode(SignUpResponse.self, from: data)
                 let user = User(id: "0",fullname: signUpResponse.data.username, email: signUpResponse.data.email, password: signUpResponse.data.password)
                 completion(.success(user))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
}
