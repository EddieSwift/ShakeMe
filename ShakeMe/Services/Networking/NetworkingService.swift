//
//  NetworkingService.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 8/14/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Alamofire
import SwiftyJSON

private let apiUrl = "https://8ball.delegator.com/magic/JSON/Why%20are%20you%20shaking%20me"

public enum NetworkResponse {
    case success(_ answer: String)
    case error(_ error: Error)
}

protocol NetworkingServiceProvider {
    func getAnswer(completion: @escaping (NetworkResponse) -> Void)
}

final public class NetworkingService: NetworkingServiceProvider {
    func getAnswer(completion: @escaping (NetworkResponse) -> Void) {
        Alamofire.request(apiUrl).responseJSON { response in
            if response.result.value != nil {
                let json = JSON(response.result.value!)
                let answer = json["magic"]["answer"].stringValue
                completion(.success(answer))
            } else {
                guard let error = response.error else {
                    completion(.error(response.error!))
                    return
                }
                completion(.error(error))
            }
        }
    }
}
