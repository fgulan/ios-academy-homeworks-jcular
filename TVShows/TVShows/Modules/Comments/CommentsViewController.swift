//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Jure Cular on 01/08/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import PromiseKit

class CommentsViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet weak var _commentTextField: UITextField!
    @IBOutlet weak var _contentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var _tableView: UITableView! {
        didSet {
            _tableView.delegate = self
            _tableView.dataSource = self

            _loadComments(withToken: _token, episodeID: _episodeID)

            _tableView.rowHeight = UITableViewAutomaticDimension
            _tableView.estimatedRowHeight = 300

            _tableView.refreshControl = _refreshControl
            _refreshControl.tintColor = UIColor.ts_pink
            _refreshControl.addTarget(self, action: #selector(_refreashData), for: .valueChanged)
        }
    }

    // MARK: - Private properties -

    private var _token: String!
    private var _episodeID: String!
    private var _comments: [Comment] = [] {
        didSet {
            if _comments.count > 0 {
                title = "Comments"
            } else {
                title = nil
            }
        }
    }

    private let _refreshControl = UIRefreshControl()

    // MARK: - Init -

    public class func initFromStoryboard(withToken token: String, episodeID: String) -> CommentsViewController {
        let commentsStoryboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsViewController = commentsStoryboard.instantiateInitialViewController() as! CommentsViewController
        commentsViewController._token = token
        commentsViewController._episodeID = episodeID

        return commentsViewController
    }

    // MARK: - Lifeciycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonImage = UIImage(named:
            "ic-navigate-back")?.withRenderingMode(.alwaysOriginal)
        let backItem = UIBarButtonItem(image: backButtonImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(_didSelectBack))
        navigationItem.leftBarButtonItem = backItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        _registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        _unregisterNotifications()
    }

    // MARK: - IBActions -

    @IBAction private func _didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapPostButton(_ sender: Any) {
        guard let comment = _commentTextField.text else { return }
        _postComment(withToken: _token, episodeID: _episodeID, text: comment)
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
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)
        else { return }
        _contentViewBottomConstraint.constant = keyboardRect.size.height
        UIView.animate(withDuration: animationDuration.doubleValue) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func _keyboardWillHide(notification: NSNotification){
        guard
            let userInfo = notification.userInfo,
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)
        else { return }
        _contentViewBottomConstraint.constant = 0
        UIView.animate(withDuration: animationDuration.doubleValue) { [weak self] in
            self?.view.layoutIfNeeded()
        }

    }

    // MARK: - Private -

    @objc private func _didSelectBack() {
        navigationController?.popViewController(animated: true)
    }


}

extension CommentsViewController: Progressable, Alertable {

    // MARK: - Data loading -

    @objc private func _refreashData() {
        _loadComments(withToken: _token, episodeID: _episodeID)
    }

    private func _loadComments(withToken token: String, episodeID: String) {
        showProgressView()

        firstly {
            APIManager.getComments(withToken: token, forEpisodeID: episodeID)
        }.done { [weak self] (comments: [Comment]) in
            guard let `self` = self else { return }
            self._comments = comments
            self._tableView.reloadData()
            if self._refreshControl.isRefreshing {
                self._refreshControl.endRefreshing()
            }
        }.catch { [weak self] error in
            self?.showAlertView(title: "Failed to fetch comments",
                                    message: "Failed to fetch comments, please check your internet connection.")
        }.finally{ [weak self] in
            self?.hideProgress()
        }
    }

    private func _postComment(withToken token: String, episodeID: String, text: String) {
        showProgressView()

        firstly {
            APIManager.postComment(withToken: token, forEpisodeID: episodeID, text: text)
            }.done { [weak self] (comment: Comment) in
                guard let `self` = self else { return }
                self._commentTextField.text = nil
                self._commentTextField.resignFirstResponder()
                self._loadComments(withToken: token, episodeID: episodeID)
            }.catch { [weak self] error in
                self?.showAlertView(title: "Failed to post comment", message: "Failed to post comment, please check your internet connection.")
            }.finally { [weak self] in
                self?.hideProgress()
        }
    }

}

// MARK: - UITableViewDelegate -

extension CommentsViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource -

extension CommentsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommentTableViewCell",
            for: indexPath
        ) as! CommentTableViewCell

        cell.configure(comment: _comments[indexPath.row])

        cell.selectionStyle = .none
        return cell
    }

}
