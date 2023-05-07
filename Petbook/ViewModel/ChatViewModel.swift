//
//  ChatViewModel.swift
//  Petbook
//
//  Created by user233432 on 5/5/23.
//
import SocketIO
import Foundation
class ChatViewModel: ObservableObject {
    @Published var room:ChatRoomResponse?
      @Published var contacts:[ChatContactsResponse]?
    
        @Published var chatid: getChatResponse?
    
    let serverUrl1 =  Utilities.url + "/chat/get"
    let serverUrl2 =  Utilities.url + "/chat/getmy"
    let serverUrl3 =  Utilities.url + "/chat/send"
    let serverUrl4 =  Utilities.url + "/chat/findorcreate"
    func getChat(id:String,completion: @escaping (Result<ChatRoomResponse, Error>) -> Void) {
         guard let url = URL(string: serverUrl1) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         

                           let parameters = ["id": id]
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
                 let u = try decoder.decode(ChatRoomResponse.self, from: data)
                 self.room=u;
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
    func getContacts(id:String,completion: @escaping (Result<[ChatContactsResponse], Error>) -> Void) {
         guard let url = URL(string: serverUrl2) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         

                           let parameters = ["id": id]
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
                 let u = try decoder.decode([ChatContactsResponse].self, from: data)
                 self.contacts=u;
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }

    func sendMsg(id:String,message:String,type:String,senderid:String,completion: @escaping (Result<ChatRoomResponse, Error>) -> Void) {
         guard let url = URL(string: serverUrl3) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
     
           
        var parameters = ["id": id,"message":message,"type":type,"senderid":senderid]

                 
                     
                  
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
                 let u = try decoder.decode(ChatRoomResponse.self, from: data)
                 self.room=u;
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
     
    func findorcreate(id1:String,id2:String,completion: @escaping (Result<getChatResponse, Error>) -> Void) {
         guard let url = URL(string: serverUrl4) else {
             completion(.failure(NSError(domain: "Invalid server URL", code: 0, userInfo: nil)))
             return
         }
         

                           let parameters = ["id1": id1,"id2":id2]
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
                 let u = try decoder.decode(getChatResponse.self, from: data)
                 self.chatid=u;
                 completion(.success(u))
             } catch {
                 completion(.failure(error))
             }
         }
         
         task.resume()
     }
   

   func refresh(s: SocketIOClient,id:String) {
   var socket: SocketIOClient
                                            socket = s
print("refresh")
            socket.on("refresh") { data, _ in
              print("refresh2")
                        self.getChat(id: id){ result in
                        
                            switch result {
                            case .success(let u):
                                self.room=u
                                // Handle successful sign-in
                                break
                                
                                
                            case .failure(let error):
                                // Handle sign                      -in error
                           
                                
                                print("Sign-up error:", error)
                                
                            
                        }
                    }
                }
            }
        
}
