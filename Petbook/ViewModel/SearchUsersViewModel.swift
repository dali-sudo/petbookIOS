//
//  SearchUsersViewModel.swift
//  Petbook
//
//  Created by user233432 on 4/26/23.
//

import Foundation
class SearchUserViewModel: ObservableObject {
    @Published var SearchList: [SearchResponse]?
    var SearchText:String = ""
    
    
    let serverUrl =  Utilities.url + "/user/find"
    
     
    func Search(SearchText:String,completion: @escaping (Result<[SearchResponse], Error>) -> Void) {
         guard let url = URL(string: serverUrl) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         

        let parameters = ["username": SearchText]
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
                 let u = try decoder.decode([SearchResponse].self, from: data)
                 DispatchQueue.main.async {

                 self.SearchList=u;
                 }
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
  
}

