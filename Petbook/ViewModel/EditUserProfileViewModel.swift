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
    
  
    
    
     let serverUrl = "http://172.17.3.211:9090/user/edit"
     
    func editProfile(token:String,email: String, password: String, username: String, avatar: UIImage?, completion: @escaping (Result<User, Error>) -> Void) {
         
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
        
        let parameters: [String: Any]
        if avatar != nil
        {           let imageData = avatar!.jpegData(compressionQuality: 1.0)
                    let base64String = imageData!.base64EncodedString(options: [])
            
            parameters = ["token":token, "email": email, "password": password, "username": username, "profilePic": base64String ]
              var request = URLRequest(url: url)
              request.httpMethod = "PUT"
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
                  let decoder = JSONDecoder()
                  let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                  let user = User(id: loginResponse.data._id, fullname: loginResponse.data.username, email: loginResponse.data.email, password: loginResponse.data.password, avatar: loginResponse.data.avatar)
                  completion(.success(user))
              } catch {
                  completion(.failure(error))
              }
          }
          
          task.resume()
        }
        else {
            parameters = ["token":token, "email": email, "password": password, "username": username]
              var request = URLRequest(url: url)
              request.httpMethod = "PUT"
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
                  let decoder = JSONDecoder()
                  let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                  let user = User(id: loginResponse.data._id, fullname: loginResponse.data.username, email: loginResponse.data.email, password: loginResponse.data.password, avatar: loginResponse.data.avatar)
                  completion(.success(user))
              } catch {
                  completion(.failure(error))
              }
          }
          
          task.resume()
        }
        
     }
}
