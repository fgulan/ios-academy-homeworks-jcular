//
//  ShowTableViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 18/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _showTitleLabel: UILabel!

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _showTitleLabel.text = nil
    }

    // MARK: - Public -

    public func configure(show: Show) {
        _showTitleLabel.text = show.title
    }

}
