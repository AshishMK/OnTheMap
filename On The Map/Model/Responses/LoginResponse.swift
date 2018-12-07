//
//  LoginResponse.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/27/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
struct Account : Codable {
    let registered : Bool
    let registrationKey : String
    enum CodingKeys : String, CodingKey {
        case registered
        case registrationKey = "key"
    }
}
struct Session : Codable {
    let sessionId : String
    let expiration : String
    enum CodingKeys : String, CodingKey {
        case sessionId = "id"
        case expiration = "expiration"
    }
}
struct LoginResponse : Codable {
    let account: Account
    let session: Session
    
}
