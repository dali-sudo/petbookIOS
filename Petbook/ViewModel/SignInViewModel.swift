//
//  SignInViewModedel.swift
//  Petbook
//
//  Created by user233432 on 3/28/23.
//

import Foundation

class SignInViewModel: ObservableObject {
    var email: String = ""
    var password: String = ""
    
    
    
    
    
    let serverUrl = "https://a8ae-41-225-72-82.eu.ngrok.io/user/signin"
     
     func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         
         let parameters = ["email": email, "password": password]
         
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
                 let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                 let user = User(id: loginResponse.data._id, fullname: loginResponse.data.username, email: loginResponse.data.email, password: loginResponse.data.password, avatar: loginResponse.data.avatar, token : loginResponse.data.token)
                 completion(.success(user))
             } catch {
                 completion(.failure(error))
              
                 
             }
         }
         
         task.resume()
     }
}
