//
//  VerificationCodeViewModel.swift
//  Petbook
//
//  Created by user233432 on 3/30/23.
//

import Foundation
class VerificationCodeViewModel: ObservableObject {
    var email: String = ""
    
    var code: String = ""
    
    let serverUrl = "http://172.17.3.211:9090/user/VerifCode"
     
    func Verif(email: String,code: String, completion: @escaping (Result<ForgetPasswordResponse, Error>) -> Void) {
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         
        let parameters = ["email": email,"code":code]
         
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
                 let fResponse = try decoder.decode(ForgetPasswordResponse.self, from: data)
                
                 completion(.success( fResponse ))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
}
