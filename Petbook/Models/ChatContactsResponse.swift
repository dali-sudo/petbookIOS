//
//  ChatContactsResponse.swift
//  Petbook
//
//  Created by user233432 on 5/5/23.
//

import Foundation

struct ChatContactsResponse: Codable,Equatable {
     
    var _id:String
   
    var Users:[contact]
 
    
    
   
}

                                                            
struct contact: Codable,Equatable,Identifiable {
    var id :UUID? = UUID()
    var  _id: String
                                
    var username: String
      var avatar: String

}
