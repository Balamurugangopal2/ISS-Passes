//
//  IssApi.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import Foundation

let issPassesUrlString = "http://api.open-notify.org/iss-pass.json?"

// TODO: Add other API methods to implement functionality provided by ISS API
class IssApi {
    
    typealias PassesResult = (IssPasses?, IssPassesListError?) -> Void
    
    func fetchIssPassesList(parameter: String?, completion: @escaping PassesResult) {
        guard let parameter = parameter else {
            NSLog("Latitude and Longitude are not passed")
            return
        }
        let urlString =  issPassesUrlString + parameter
        guard let url = URL(string: urlString) else { return }
        
        CoreApi.shared.sendRequest(url: url) { (data) in
            do {
                if let data = data {
                    let passes = try JSONDecoder().decode(IssPasses.self, from: data)
                    completion(passes, nil)
                } else {
                    completion(nil, .serviceError)
                }
            } catch {
                completion(nil, .serviceError)
            }
        }
    }
    
}
