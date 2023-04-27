    //
    //  ProfileViewModel.swift
    //  Petbook
    //
    //  Created by user233432 on 4/6/23.
    //

    import Foundation
    class ProfileViewModel: ObservableObject {
        var id: String = ""
        @Published var user:GetUserProfilResponse?
        @Published var follow:FollowResponse?
        
        
        
        let serverUrl = Utilities.url + "/user/getUserProfil"
        let userverUrl = Utilities.url + "/user/unfollow"
        let fserverUrl = Utilities.url + "/user/follow"
        func getProfile(id: String, completion: @escaping (Result<GetUserProfilResponse, Error>) -> Void) {
             guard let url = URL(string: serverUrl) else {
                 completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
                 return
             }
             
             let parameters = ["id":id]
                                    
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
                     let u = try decoder.decode(GetUserProfilResponse.self, from: data)
                     self.user=u;
                     completion(.success(u))
                 } catch {
                     completion(.failure(error))
                 }
             }
             
             task.resume()
         }
        func Follow(myid: String,followed:String, completion: @escaping (Result<FollowResponse, Error>) -> Void) {
             guard let url = URL(string: fserverUrl) else {
                 completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
                 return
             }
             
            let parameters = ["myid":myid,"followed":followed]
                                    
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
                     let u = try decoder.decode(FollowResponse.self, from: data)
                     self.follow=u;
                     completion(.success(u))
                 } catch {
                     completion(.failure(error))
                 }
             }
             
             task.resume()
         }
        func UnFollow(myid: String,followed:String, completion: @escaping (Result<FollowResponse, Error>) -> Void) {
             guard let url = URL(string: userverUrl) else {
                 completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
                 return
             }
             
            let parameters = ["myid":myid,"followed":followed]
                                    
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
                     let u = try decoder.decode(FollowResponse.self, from: data)
                     self.follow=u;
                     completion(.success(u))
                 } catch {
                     completion(.failure(error))
                 }
             }
             
             task.resume()
         }
    }
