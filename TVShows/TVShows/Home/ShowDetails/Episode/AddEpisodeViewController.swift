//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 26/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class AddEpisodeViewController: UIViewController {
    // MARK: - IBOutlets -

    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _episodeTitleTextField: UITextField!
    @IBOutlet weak var _seasonNumberTextField: UITextField!
    @IBOutlet weak var _episodeNumberTextField: UITextField!
    @IBOutlet weak var _episodeDescriptionTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _unregisterNotifications()
    }
    }

    }

    // MARK: - IBActions -

    @IBAction private func _didTapToHideKeyboard(_ sender: Any) {
        if _episodeTitleTextField.isFirstResponder {
            _episodeTitleTextField.resignFirstResponder()
        }
        if _seasonNumberTextField.isFirstResponder {
            _seasonNumberTextField.resignFirstResponder()
        }
        if _episodeNumberTextField.isFirstResponder {
            _episodeNumberTextField.resignFirstResponder()
        }
        if _episodeDescriptionTextField.isFirstResponder {
            _episodeDescriptionTextField.resignFirstResponder()
        }
    }

    @IBAction private func _didTapUploadPhoto(_ sender: Any) {
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
