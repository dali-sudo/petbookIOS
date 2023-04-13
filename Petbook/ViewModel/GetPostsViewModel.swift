//
//  GetPostsViewModel.swift
//  Petbook
//
//  Created by bokh on 13/4/2023.
//

import Foundation
class GetPostsViewModel: ObservableObject {
    @Published var Posts: [GetPostResponseData]?
  
    
    
    let serverUrl = "http://172.17.1.151:9090/post/getAll"
    
     
    func getPosts(completion: @escaping (Result<[GetPostResponseData], Error>) -> Void) {
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         

                                
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
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
                 let u = try decoder.decode([GetPostResponseData].self, from: data)
                 self.Posts=u;
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
}
