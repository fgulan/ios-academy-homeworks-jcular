//
//  LoginViewController.swift
//  TVShows
//
//  Created by Jure Cular on 08/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit
import KeychainAccess

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
    private let _keychain = Keychain(service: "hr.jcular.TVShows")

    // MARK: - Init -

    public static func initFromStroyboard() -> LoginViewController {
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginViewController
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _loginIfUserRemembered()
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

    @IBAction private func _didTapLogInButton(_ sender: Any) {
        guard
            let email = _emailTextField.text,
            let password = _passwordTextField.text
        else { return }

        if (email == "") {
            _shakeTextField(textField: _emailTextField)
            return
        }
        if (password == "") {
            _shakeTextField(textField: _passwordTextField)
            return
        }

        _loginUser(email: email, password: password)
    }

    @IBAction private func _didTapCreateAccountButton(_ sender: Any) {
        guard
            let email = _emailTextField.text,
            let password = _passwordTextField.text
        else { return }

        if (email == "") {
            _shakeTextField(textField: _emailTextField)
            return
        }
        if (password == "") {
            _shakeTextField(textField: _passwordTextField)
            return
        }

        _registerUser(email: email, password: password)
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

    // MARK: - Navigation -

    private func _presentHomeViewController(withLoginUser loginUser: LoginData) {
        let homeViewController = HomeViewController.initFromStoryboard(with: loginUser)
        navigationController?.setViewControllers([homeViewController], animated: true)
    }

    // MARK: - Animations -

    private func _shakeTextField(textField: UITextField) {
        let keyPath = "position"
//        textField.layer.removeAnimation(forKey: keyPath)

        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 5, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 5, y: textField.center.y))

        textField.layer.add(animation, forKey: keyPath)
    }

    private func _pulseButton(button: UIButton) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.autoreverse, .curveEaseOut],
                       animations: {
                        button.backgroundColor = UIColor.red
        }) { (finished) in
            button.backgroundColor = UIColor.ts_pink
        }
    }

}

extension LoginViewController: Progressable, Alertable {

    // MARK: - Login user -

    private func _loginUser(email: String, password: String) {
        showProgressView()

        firstly {
            return APIManager.loginUser(withEmail: email, password: password)
        }.done { [weak self] (loginUser: LoginData) in
            guard let `self` = self else { return }
            self._rememberUserIfNeeded()
            self._loginUser = loginUser
            self._presentHomeViewController(withLoginUser: loginUser)
        }.catch { [weak self] error in
            guard let `self` = self else { return }
            self._pulseButton(button: self._logInButton)
            self.showAlertView(title: "Login failed",
                               message: "Unable to login using provided email and password.")
        }.finally { [weak self] in
            self?.hideProgress()
        }
    }

    private func _registerUser(email: String, password: String) {
        showProgressView()

        firstly {
            APIManager.registerUser(withEmail: email, password: password)
        }.then{ [weak self] (user: User)-> Promise<LoginData> in
            self?._user = user
            return APIManager.loginUser(withEmail: email, password: password)
        }.done { [weak self] (loginUser: LoginData) in
            guard let `self` = self else { return }
            self._rememberUserIfNeeded()
            self._loginUser = loginUser
            self._presentHomeViewController(withLoginUser: loginUser)
        }.catch { [weak self] error in
            self?.showAlertView(title: "Registration failed",
                                message: "Unable to register using provided email and password.")
        }.finally { [weak self] in
            self?.hideProgress()
        }
    }

    private func _rememberUserIfNeeded() {
        if _rememberMeCheckmark.isSelected {
            _keychain["email"] = self._emailTextField.text
            _keychain["password"] = self._passwordTextField.text
        }
    }

    private func _loginIfUserRemembered() {
        guard
            let emailOptional = try? _keychain.getString("email"),
            let passwordOptional = try? _keychain.getString("password"),
            let email = emailOptional,
            let password = passwordOptional
        else { return }
        _loginUser(email: email, password: password)
    }

}
