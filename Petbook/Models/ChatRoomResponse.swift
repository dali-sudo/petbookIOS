//
//  ChatRoomResponse.swift
//  Petbook
//
//  Created by user233432 on 5/5/23.
//

import Foundation
struct ChatRoomResponse: Codable,Equatable {
     
    var _id:String
    var   chat:[chat]
    var Users:[users]
 

    
   
}
struct chat: Codable,Equatable {
  
    var _id:String
    var message: String

    var  type: String
    var senderid:String
}
                                                            
struct users : Codable,Equatable,Identifiable {
    var id :UUID? = UUID()
    var  _id: String
                                                
    var username: String

}
