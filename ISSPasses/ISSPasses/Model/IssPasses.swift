//
//  PassesModel.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/17/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation

struct IssPasses: Decodable {
    
    let message: String?
    let request: PassRequest?
    let response: [PassResponse]?
    
}

struct PassRequest: Decodable {
    
    let latitude: Double?
    let longitude: Double?
    let altitude: Double?
    let passes: Int?
    let datetime: Date?
    
}

struct PassResponse: Decodable {
    
    let duration: Int?
    let risetime: Double?
    
}
