//
//  StudentLocation.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/27/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
struct StudentLocation : Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId:  String
    let uniqueKey: String
    let updatedAt: String
    
    //some of keys are missing from response i.e safe parsing
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        self.objectId = try container.decodeIfPresent(String.self, forKey: .objectId) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        self.mapString = try container.decodeIfPresent(String.self, forKey: .mapString) ?? ""
        self.mediaURL = try container.decodeIfPresent(String.self, forKey: .mediaURL) ?? ""
        self.uniqueKey = try container.decodeIfPresent(String.self, forKey: .uniqueKey) ?? ""
    }
}
