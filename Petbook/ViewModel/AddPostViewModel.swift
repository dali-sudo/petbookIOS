//
//  AddPostViewModel.swift
//  Petbook
//
//  Created by bokh on 12/4/2023.
//

import Foundation
import UIKit
class AddPostViewModel: ObservableObject {
    var descreption: String = ""
    
    var images: [UIImage]? = nil
    var petIds: [String]? = nil
    var owner:String=""
    let serverUrl = "http://172.17.3.211:9090/post/AddPost"
    var base64Strings: [String] = []
    func AddPost(owner: String,descreption: String,images: [UIImage]?,petIds: [String]? ,completion: @escaping (Result<ForgetPasswordResponse, Error>) -> Void) {
        guard let url = URL(string: serverUrl) else {
            completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any]

            if images != nil {
                if let images = images {
            
                    for image in images {
                        if let imageData = image.jpegData(compressionQuality: 1.0) {
                            let base64String = imageData.base64EncodedString(options: [])
                            base64Strings.append(base64String)
                        }
                    }
                    // do something with the base64Strings array
                } else {
                    // handle the case where images is nil
                }
                parameters = ["owner":owner, "descreption": descreption, "images": base64Strings,"tags":petIds!]
            
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
    
    

else
{
    
    parameters = ["owner":owner, "descreption": descreption]
    
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

}
