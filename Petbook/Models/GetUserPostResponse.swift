//
//  GetUserPostResponse.swift
//  Petbook
//
//  Created by user233432 on 4/6/23.
//

import Foundation
class GetUserPostResponse: Codable, Equatable {
    var _id: String
    var images: [String]
    
    static func == (lhs: GetUserPostResponse, rhs: GetUserPostResponse) -> Bool {
           return lhs._id == rhs._id && lhs.images == rhs.images
       }
   }
