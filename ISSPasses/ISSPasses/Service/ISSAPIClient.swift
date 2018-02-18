//
//  APIClient.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation

let issPassUrltring = "http://api.open-notify.org/iss-pass.json?"

// TODO: Add other API methods to implement functionality provided by ISS API
class ISSAPIClient {
    
    func fetchISSPassesList(parameter: String?, completion: @escaping (Passes?) -> ()) {
        guard let parameter = parameter else {
            NSLog("Latitude and Longitude are not passed")
            return
        }
        let urlString =  issPassUrltring + parameter
        guard let url = URL(string: urlString) else { return }
        
        CoreAPI.shared.sendRequest(url: url) { (data) in
            do {
                if let data = data {
                    let passes = try JSONDecoder().decode(Passes.self, from: data)
                    completion(passes)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
    }
    
}
