//
//  ShowDescriptionTableViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 24/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class ShowDescriptionTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _showTitleLabel: UILabel!
    @IBOutlet private weak var _showDescriptionLabel: UILabel!
    @IBOutlet private weak var _episodesNumberLabel: UILabel!

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _showTitleLabel.text = nil
        _showDescriptionLabel.text = nil
        _episodesNumberLabel.text = nil
    }

    // MARK: - Public -

    public func configure(showDetails: ShowDetails, episodesNumber: Int) {
        _showTitleLabel.text = showDetails.title
        _showDescriptionLabel.text = showDetails.description
        _episodesNumberLabel.text = String(episodesNumber)
    }

}
