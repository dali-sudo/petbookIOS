//
//  LikeResponse.swift
//  Petbook
//
//  Created by user233432 on 4/26/23.
//

import Foundation
struct LikeResponse: Codable,Equatable{
   
    var _id:String
    var   descreption:String
 

    var  likescount:Int
    var owner:String
  var images:[String]?
    var tags:[String]?
    var likes:[String]?
    
    
   
}
