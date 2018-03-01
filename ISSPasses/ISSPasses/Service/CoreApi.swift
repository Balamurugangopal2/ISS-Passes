//
//  CoreApi.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation

enum HttpType: String {
    
    case GET
    case POST
    case PUT
    
}

// Singleton class handles the network communications
class CoreApi {
    public static let shared = CoreApi()
    
    private init() {
        
    }
    
    // TODO: - Presently, this method supports only GET request and later add support for POST, PUT requests.
    func sendRequest(url: URL, completion: @escaping (Data?) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, _, error) in
            if error == nil {
                completion(data)
            } else {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
}
