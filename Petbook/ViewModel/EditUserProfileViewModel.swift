//
//  EditUserProfileViewModel.swift
//  Petbook
//
//  Created by user233432 on 3/31/23.
//

import Foundation
import UIKit

class EditUserProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var image: UIImage? = nil
    
  
    
    
     let serverUrl = "https://54e3-102-28-7-62.eu.ngrok.io/user/edit"
     
     func editProfile(email: String, password: String, username: String, avatar: UIImage?, completion: @escaping (Result<User, Error>) -> Void) {
         
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         
         let parameters: [String: Any] = ["email": email, "password": password, "username": username]
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
         
         // If an avatar image was provided, convert it to a base64 string and add it to the request body
         if let avatar = avatar, let base64String = avatar.pngData()?.base64EncodedString() {
             let avatarParameter: [String: Any] = ["avatar": base64String]
             request.httpBody?.append("&".data(using: .utf8)!)
             request.httpBody?.append(try! JSONSerialization.data(withJSONObject: avatarParameter))
         }
         
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
                 let decoder = JSONDecoder()
                 let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                 let user = User(id: loginResponse.data._id, fullname: loginResponse.data.username, email: loginResponse.data.email, password: loginResponse.data.password)
                 completion(.success(user))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
}
