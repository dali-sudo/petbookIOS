//
//  SearchResponse.swift
//  Petbook
//
//  Created by user233432 on 4/26/23.
//

import Foundation
struct SearchResponse : Codable,Equatable ,Hashable {
    var id : UUID? = UUID()
    var  _id: String
                                
    var username: String

    var  avatar: String?
   
}
