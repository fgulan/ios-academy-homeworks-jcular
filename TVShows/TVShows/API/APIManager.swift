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

    public static func registerUserWith(email: String, password: String, successCallback: @escaping ((User) -> Void), failureCallback: @escaping ((Error) -> Void)) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        firstly {
            Alamofire
                .request(_registerUserURL,
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
        }.done { user in
            successCallback(user)
        }.catch { error in
            failureCallback(error)
        }.finally {
            SVProgressHUD.dismiss()
        }
    }

    public static func loginUserWith(email: String, password: String, successCallback: @escaping ((LoginData) -> Void), failureCallback: @escaping ((Error) -> Void)) {
        SVProgressHUD.show()

        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        firstly {
            Alamofire
                .request(_loginUserURL,
                         method: .post,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
        }.done { loginUser in
            successCallback(loginUser)
        }.catch { error in
            failureCallback(error)
        }.finally {
            SVProgressHUD.dismiss()
        }
    }

}

extension APIManager {

    // MARK: - API URLs -

    private static let _URL = "https://api.infinum.academy/api"

    private static let _loginUserURL = "\(_URL)/users/sessions"
    private static let _registerUserURL = "\(_URL)/users"

}
