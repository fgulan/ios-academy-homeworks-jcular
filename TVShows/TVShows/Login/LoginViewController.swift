//
//  LoginViewController.swift
//  TVShows
//
//  Created by Jure Cular on 08/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var numberOfTaps = 0

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.button.layer.cornerRadius = 5.0
        self.updateLabelWithTapNumber()
    }

    @IBAction func didTapButton(_ sender: Any) {
        print("Button tapped")
        numberOfTaps += 1
        self.updateLabelWithTapNumber()
        self.startOrStopActivityIndicator()
    }

    private func updateLabelWithTapNumber() {
        self.label.text = String(self.numberOfTaps)
    }

    private func startOrStopActivityIndicator() {
        if (self.activityIndicator.isAnimating) {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
    }

}
