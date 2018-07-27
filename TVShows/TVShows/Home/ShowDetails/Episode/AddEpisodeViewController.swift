//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 26/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit

protocol AddEpisodeViewControllerDelegate: class {

    func succesfullyAddedEpisode();

}

class AddEpisodeViewController: UIViewController, Alertable, Progressable {

    // MARK: - Public properties -

    public weak var delegate: AddEpisodeViewControllerDelegate?

    // MARK: - IBOutlets -

    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _episodeTitleTextField: UITextField!
    @IBOutlet weak var _seasonNumberTextField: UITextField!
    @IBOutlet weak var _episodeNumberTextField: UITextField!
    @IBOutlet weak var _episodeDescriptionTextField: UITextField!

    // MARK: - Private properties -

    private var _token: String!
    private var _showID: String!

    // MARK: - Init -

    public class func initFromStoryboard(withToken token: String, showID: String) -> AddEpisodeViewController {
        let addEpisodeStoryboard = UIStoryboard(name: "AddEpisode", bundle: nil)
        let addEpisodeViewController = addEpisodeStoryboard.instantiateInitialViewController() as! AddEpisodeViewController
        addEpisodeViewController._token = token
        addEpisodeViewController._showID = showID
        addEpisodeViewController.title = "Add episode"

        return addEpisodeViewController
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _unregisterNotifications()
    }

    private func _setupNavigationItem() {
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(_didSelectCancel))
        cancelButton.tintColor = UIColor.ts_pink
        navigationItem.leftBarButtonItem = cancelButton

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(_didSelectAddShow))
        addButton.tintColor = UIColor.ts_pink
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func _didSelectAddShow() {
        showProgressView()

        firstly{ [weak self] in
            APIManager.addEpisode(
                withToken: _token,
                showID: _showID,
                mediaID: "",
                title: self?._episodeTitleTextField.text,
                description: self?._episodeDescriptionTextField.text,
                episodeNumber: self?._episodeNumberTextField.text,
                season: self?._seasonNumberTextField.text)
        }.done { [weak self] (episode: Episode) in
            guard let `self` = self else { return }
            self.delegate?.succesfullyAddedEpisode()
            self.navigationController?.dismiss(animated: true)
        }.catch { [weak self] error in
            self?.showAlertView(title: "Unable to add episode",
                                message: "Unable to add episode please check your internet connection.")
        }.finally { [weak self] in
            self?.hideProgress()
        }
    }

    @objc private func _didSelectCancel() {
        navigationController?.dismiss(animated: true)
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
