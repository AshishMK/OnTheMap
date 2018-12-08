//
//  ErrorResponse.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/8/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
struct ErrorResponse : Codable{
    let statusCode: Int
    let errorMessage: String
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case errorMessage = "error"
    }
}
extension ErrorResponse: LocalizedError {
    var errorDescription : String? {
        return errorMessage
    }
    
}
