//
//  GetPostsViewModel.swift
//  Petbook
//
//  Created by bokh on 13/4/2023.
//

import Foundation
class GetPostsViewModel: ObservableObject {
    @Published var Posts: [GetPostResponseData]?
    @Published var RandomPosts: [DiscoverPostResponse]? 
    @Published var liked: LikeResponse?
    
    
    let serverUrl =  Utilities.url + "/post/getAll"
    
    let likeserverUrl =  Utilities.url + "/post/like"
    let dislikeserverUrl =  Utilities.url + "/post/unlike"
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
    
    let serverUrl2 = Utilities.url + "/post/discover"
    func getRandomPosts(completion: @escaping (Result<[DiscoverPostResponse], Error>) -> Void) {
        print("forwarding to ", serverUrl)
         guard let url = URL(string: serverUrl2) else {
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
                 let u = try decoder.decode([DiscoverPostResponse].self, from: data)
                 self.RandomPosts=u;
                 
                 print(self.RandomPosts!.count)
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
    
    func like(id:String,like:String,completion: @escaping (Result<LikeResponse, Error>) -> Void) {
        guard let url = URL(string: likeserverUrl) else {
            completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
            return
        }
        
       let parameters = ["id": id,"like":like]
                               
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
                let u = try decoder.decode(LikeResponse.self, from: data)
                self.liked=u;
                completion(.success(u))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func dislike(id:String,like:String,completion: @escaping (Result<LikeResponse, Error>) -> Void) {
        guard let url = URL(string: dislikeserverUrl) else {
            completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
            return
        }
        
       let parameters = ["id": id,"like":like]
                               
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
                let u = try decoder.decode(LikeResponse.self, from: data)
                self.liked=u;
                completion(.success(u))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
