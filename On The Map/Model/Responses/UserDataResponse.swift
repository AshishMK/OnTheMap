//
//  UserDataResponse.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/4/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
struct UserDataResponse : Codable{
    let firstName: String
    let lastName: String
    let email: Email
    
    enum CodingKeys : String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}
struct Email : Codable{
    let address: String
    
}


