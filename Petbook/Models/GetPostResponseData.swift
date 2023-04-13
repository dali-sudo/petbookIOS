//
//  GetPostResponseData.swift
//  Petbook
//
//  Created by bokh on 13/4/2023.
//

import Foundation
struct GetPostResponseData: Codable,Equatable{
   
    var _id:String
    var   descreption:String
 
var   owner:owner
    var  likescount:Int
    
  var images:[String]?
    
    
   
}
struct owner: Codable,Equatable {
    var  _id: String
   
    var username: String

    var  avatar: String?
   
}
