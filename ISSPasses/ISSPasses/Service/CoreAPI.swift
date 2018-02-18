//
//  CoreAPI.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation

enum HTTPType: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

// Singleton class handles the network communications
class CoreAPI {
    public static let shared: CoreAPI = CoreAPI()
    
    private init() {
        
    }
    
    // TODO: - Presently, this method supports only GET request and later add support for POST, PUT requests.
    func sendRequest(url: URL, completion: @escaping (Data?)->()) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, URLResponse, error) in
            if error == nil {
                completion(data)
            } else {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
}
