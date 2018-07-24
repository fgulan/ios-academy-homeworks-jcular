//
//  APIManager.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

class APIManager {

    public static func registerUser(withEmail email: String, password: String) -> Promise<User> {
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        return Alamofire
            .request(_registerUserURL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func loginUser(withEmail email: String, password: String) -> Promise<LoginData>{
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        return Alamofire
            .request(_loginUserURL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func getShows(withToken token: String) -> Promise<[Show]> {

        let headers = ["Authorization": token]

        return Alamofire
            .request(_showsURL,
                        method: .get,
                        encoding: JSONEncoding.default,
                        headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

}

extension APIManager {

    // MARK: - API URLs -

    private static let _URL = "https://api.infinum.academy/api"

    private static let _loginUserURL = "\(_URL)/users/sessions"
    private static let _registerUserURL = "\(_URL)/users"

    private static let _showsURL = "\(_URL)/shows"
}
