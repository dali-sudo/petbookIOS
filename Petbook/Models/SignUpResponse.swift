//
//  SignUpResponse.swift
//  Petbook
//
//  Created by user233432 on 3/30/23.
//

import Foundation
struct SignUpResponse: Codable {
    let data: Data
    let error: String?
    let message: String?
    
    struct Data: Codable {
        let username: String
        let password: String
        let email: String
    
       
    }
}
