//
//  Alertable.swift
//  TVShows
//
//  Created by Jure Cular on 23/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation
import UIKit

protocol Alertable: class {

    func showAlertView(title: String?, message: String?)

}

extension Alertable where Self: UIViewController {

    func showAlertView(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}
