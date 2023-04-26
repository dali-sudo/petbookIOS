//
//  GetUserProfilResponse.swift
//  Petbook
//
//  Created by user233432 on 4/6/23.
//

import Foundation

class GetUserProfilResponse: Codable, Equatable {
    var user:data2
    var posts: [data]
    
    static func == (lhs: GetUserProfilResponse, rhs: GetUserProfilResponse) -> Bool {
            return lhs.user == rhs.user && lhs.posts == rhs.posts
        }
       }

struct data:Codable, Equatable, Hashable{
    var _id: String
    var images: [String]
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    static func == (lhs: data, rhs: data) -> Bool {
          return lhs._id == rhs._id && lhs.images == rhs.images
      }
}
struct data2:Codable, Equatable{
        var _id: String
        var username: String
        var followingcount: Int
        var followerscount: Int
    var followers: [String]
        var avatar:String
    static func == (lhs: data2, rhs: data2) -> Bool {
          return lhs._id == rhs._id && lhs.username == rhs.username && lhs.followingcount == rhs.followingcount && lhs.followerscount == rhs.followerscount && lhs.avatar == rhs.avatar
      }    }
