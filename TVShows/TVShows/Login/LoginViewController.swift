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
    @IBOutlet private weak var _emailTextField: UITextField!
    @IBOutlet private weak var _passwordTextField: UITextField!
    @IBOutlet private weak var _logInButton: UIButton!
    @IBOutlet private weak var _rememberMeCheckmark: UIButton!

    // MARK: - Private properties -

    private var _user: User?
    private var _loginUser: LoginData?

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
        if _emailTextField.isFirstResponder {
            _emailTextField.resignFirstResponder()
        }
        if _passwordTextField.isFirstResponder {
            _passwordTextField.resignFirstResponder()
        }
    }

    @IBAction func _didTapLogInButton(_ sender: Any) {
        guard
            let email = _emailTextField.text,
            let password = _passwordTextField.text
        else { return }

        APIManager.loginUserWith(
            email: email,
            password: password,
            successCallback: { [weak self] (loginUser) in
                self?._loginUser = loginUser

                let homeViewController = HomeViewController.initFromStoryboard()
                self?.navigationController?.pushViewController(homeViewController, animated: true)
            },
            failureCallback: { (error) in
                print("API error: \(error)")
        })
    }

    @IBAction func _didTapCreateAccountButton(_ sender: Any) {
        guard
            let email = _emailTextField.text,
            let password = _passwordTextField.text
        else { return }

        APIManager.registerUserWith(
            email: email,
            password: password,
            successCallback: { [weak self] (user) in
                self?._user = user

                let homeViewController = HomeViewController.initFromStoryboard()
                self?.navigationController?.pushViewController(homeViewController, animated: true)
            },
            failureCallback: { (error) in
                print("API error: \(error)")
        })
    }

    // MARK: - Notifications -

    private func _registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }

    private func _unregisterNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }

    @objc private func _keyboardWillShow(notification: NSNotification){
        guard
            let userInfo = notification.userInfo,
            let keyboardRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        _scrollView.contentInset.bottom = keyboardRect.size.height
        _scrollView.scrollIndicatorInsets.bottom = keyboardRect.size.height
    }

    @objc private func _keyboardWillHide(notification: NSNotification){
        _scrollView.contentInset.bottom = 0
        _scrollView.scrollIndicatorInsets.bottom = 0
    }

}
