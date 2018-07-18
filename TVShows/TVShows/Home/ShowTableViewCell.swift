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

    // MARK: - Private properties -

    private var _show: Show?

    // MARK: - Lifecycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func prepareForReuse() {
        self._show = nil
        self._showTitleLabel.text = nil
    }

    // MARK: - Public -

    public func configure(show: Show) {
        self._show = show
        self._showTitleLabel.text = show.title
    }

}