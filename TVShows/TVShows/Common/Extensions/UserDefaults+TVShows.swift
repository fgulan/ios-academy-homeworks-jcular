//
//  UserDefaults+TVShows.swift
//  TVShows
//
//  Created by Jure Cular on 29/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation

extension UserDefaults {

    enum ts {
    // MARK: - Keys -

        private static let _shouldUseGridKey = "tvshows.shouldUseGrid"

        // MARK: - HomeViewController Layout -

        public static var shouldUseGrid: Bool {
            set {
                UserDefaults.standard.set(newValue, forKey: ts._shouldUseGridKey)
            }
            get {
                guard
                    let _shouldUseGridKey = UserDefaults.standard.value(forKey: ts._shouldUseGridKey) as? Bool
                    else { return true }
                return _shouldUseGridKey
            }
        }
    }

}
