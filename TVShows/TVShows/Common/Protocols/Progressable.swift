//
//  Progressable.swift
//  TVShows
//
//  Created by Jure Cular on 19/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol Progressable: class {

    func showProgressView(message: String?)
    func hideProgress()

}

extension Progressable {

    func showProgressView(message: String? = nil) {
        let status = message ?? ""
        SVProgressHUD.show(withStatus: status)
    }

    func hideProgress() {
        SVProgressHUD.dismiss()
    }

}
