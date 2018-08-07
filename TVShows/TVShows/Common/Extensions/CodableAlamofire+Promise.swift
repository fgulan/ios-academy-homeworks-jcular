//
//  CodableAlamofire+Promise.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import PromiseKit

extension Alamofire.DataRequest {

    public func responseDecodableObject<T: Decodable>(queue: DispatchQueue? = nil, keyPath: String? = nil, decoder: JSONDecoder = JSONDecoder()) -> Promise<T> {
        return Promise { seal in
            responseDecodableObject(queue: queue, keyPath: keyPath, decoder: decoder, completionHandler: { (response: DataResponse<T>) in
                switch response.result {
                case .success(let value):
                    seal.fulfill(value)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
    
}
