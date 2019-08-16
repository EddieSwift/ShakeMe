//
//  NetworkingService.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/14/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public enum NetworkingState {
    case success(_ answer: String)
    case error(_ error: Error)
    case none
}

public class NetworkingService {
    
    public static let shared = NetworkingService()
    
    public func getAnswer(_ apiUrl: String, completion: @escaping (NetworkingState) -> ()) {
        
        Alamofire.request(apiUrl).responseJSON { response in
            if response.result.value != nil {
                
                let json = JSON(response.result.value!)
                let answer = json["magic"]["answer"].stringValue
                completion(.success(answer))
                
            } else {
                guard let error = response.error else {
                    completion(.none)
                    return
                }
                completion(.error(error))
            }
        }
    }
    
}


