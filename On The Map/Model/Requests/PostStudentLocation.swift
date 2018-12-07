//
//  StudentLocation.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/4/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
struct PostStudentLocation : Codable{
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
}
