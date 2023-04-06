//
//  LoginRequest.swift
//  Petbook
//
//  Created by user233432 on 3/28/23.
//

import Foundation
struct LoginResponse: Codable {
    let data: Data
    let error: String?
    let message: String?
    
    struct Data: Codable {
        let _id: String
        let email: String
        let username: String
        let password: String
        let token: String?
        let avatar: String?
       
    }
}
