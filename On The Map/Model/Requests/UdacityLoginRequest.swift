//
//  LoginRequest.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/27/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
struct LoginRequest : Codable {
    let userName : String
    let password : String
    enum CodingKeys : String, CodingKey{
        case userName = "username"
        case password
    }
}
struct UdacityLoginRequest : Codable {
    let udacity : LoginRequest
}
