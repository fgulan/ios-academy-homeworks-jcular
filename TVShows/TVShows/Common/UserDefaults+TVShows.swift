//
//  UserDefaults+TVShows.swift
//  TVShows
//
//  Created by Jure Cular on 29/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation

extension UserDefaults {

    private static let passwordKey = "tvshows.password"
    private static let emailKey = "tvshows.email"

    public static var tv_userPassword: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.passwordKey)
        }
        get {
            guard
                let password = UserDefaults.standard.value(forKey: UserDefaults.passwordKey) as? String
            else { return nil }
            return password
        }
    }

    public static var tv_userEmail: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.emailKey)
        }
        get {
            guard
                let email = UserDefaults.standard.value(forKey: UserDefaults.emailKey) as? String
                else { return nil }
            return email
        }
    }

    public static func clearUserCredidentials() {
        UserDefaults.standard.removeObject(forKey: emailKey)
        UserDefaults.standard.removeObject(forKey: passwordKey)
    }

}
