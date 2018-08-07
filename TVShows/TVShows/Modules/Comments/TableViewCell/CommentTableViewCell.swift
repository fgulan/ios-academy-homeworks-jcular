//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 01/08/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _userEmailLabel: UILabel!
    @IBOutlet private weak var _commentLabel: UILabel!
    @IBOutlet private weak var _userImageView: UIImageView!

    // MARK: - Private properties -

    private let _userImageNames = [
        "img-placeholder-user1",
        "img-placeholder-user2",
        "img-placeholder-user3"
    ]

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _userEmailLabel.text = nil
        _commentLabel.text = nil
        _userImageView.image = nil
    }

    // MARK: - Public -

    public func configure(comment: Comment) {
        _userEmailLabel.text = comment.userEmail
        _commentLabel.text = comment.text
        
        let index = abs(comment.userEmail.hashValue) % 3
        _userImageView.image = UIImage(named:_userImageNames[index])
    }

}
