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

class APIManager {

    public static func registerUserWith(email: String, password: String, successCallback: @escaping ((User) -> Void), failureCallback: @escaping ((Error) -> Void)) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        Alamofire
            .request(_registerUserURL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (dataResponse: DataResponse<User>) in

                SVProgressHUD.dismiss()

                switch dataResponse.result {
                    case .success(let user):
                        successCallback(user)
                    case .failure(let error):
                        failureCallback(error)
                }
        }
    }

    public static func loginUserWith(email: String, password: String, successCallback: @escaping ((LoginData) -> Void), failureCallback: @escaping ((Error) -> Void)) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        Alamofire
            .request(_loginUserURL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (dataResponse: DataResponse<LoginData>) in

                SVProgressHUD.dismiss()

                switch dataResponse.result {
                    case .success(let loginUser):
                        successCallback(loginUser)
                    case .failure(let error):
                        failureCallback(error)
                }
        }
    }

}

extension APIManager {

    // MARK: - API URLs -

    private static let _URL = "https://api.infinum.academy/api"

    private static let _loginUserURL = "\(_URL)/users/sessions"
    private static let _registerUserURL = "\(_URL)/users"

}
