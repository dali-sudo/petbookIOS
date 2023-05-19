//
//  PetResponse.swift
//  Petbook
//
//  Created by user233432 on 4/9/23.
//

import Foundation

struct PetResponse: Codable,Identifiable,Equatable{
    var id: String?
    var petName: String?
    var petType: String?
    var race: String?
    var petPic: String?
    var sexe: String?
    var petOwner: String?
    var petAge: String?
    var images: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case petName = "name"
        case petType = "type"
        case race
        case petPic = "avatar"
        case sexe
        case petOwner = "owner"
        case petAge = "age"
        case images
    }
}
