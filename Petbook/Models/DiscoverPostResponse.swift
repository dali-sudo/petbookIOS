//
//  DiscoverPostResponse.swift
//  Petbook
//
//  Created by user233432 on 4/17/23.
//

import Foundation


struct DiscoverPostResponse: Identifiable,Codable,Equatable,Hashable {
    var id : UUID? = UUID()
    var _id:String
    var  image:String
}
