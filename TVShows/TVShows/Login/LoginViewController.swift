//
//  LoginViewController.swift
//  TVShows
//
//  Created by Jure Cular on 08/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _scrollView: UIScrollView!
    @IBOutlet private weak var _usernameTextField: UITextField!
    @IBOutlet private weak var _passwordTextField: UITextField!
    @IBOutlet private weak var _logInButton: UIButton!
    @IBOutlet private weak var _rememberMeCheckmark: UIButton!

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _logInButton.layer.cornerRadius = 5.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _unregisterNotifications()
    }

    // MARK: - IBActions -

    @IBAction private func _didPressRememberMeCheckmark(_ sender: Any) {
        _rememberMeCheckmark.isSelected = !_rememberMeCheckmark.isSelected
    }

    @IBAction private func _didTapToHideKeyboard(_ sender: Any) {
        if _usernameTextField.isFirstResponder {
            _usernameTextField.resignFirstResponder()
        }
        if _passwordTextField.isFirstResponder {
            _passwordTextField.resignFirstResponder()
        }
    }

    @IBAction func _didTapLogInButton(_ sender: Any) {
        guard
            let username = _usernameTextField.text,
            let password = _passwordTextField.text
        else { return }
    }

    @IBAction func _didTapCreateAccountButton(_ sender: Any) {
        guard
            let username = _usernameTextField.text,
            let password = _passwordTextField.text
        else { return }
    }

    // MARK: - Notifications -

    private func _registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    private func _unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc private func _keyboardWillShow(notification: NSNotification){
        guard
            let userInfo = notification.userInfo,
            let keyboardRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        _scrollView.contentInset.bottom = keyboardRect.size.height
    }

    @objc private func _keyboardWillHide(notification: NSNotification){
        _scrollView.contentInset.bottom = 0
    }

}

    }

    }

}
