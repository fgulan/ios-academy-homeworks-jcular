//
//  ShowListCollectionViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 29/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class ShowListCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _showTitleLabel: UILabel!
    @IBOutlet private weak var _showImageView: UIImageView!

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _showImageView.image = nil
        _showTitleLabel.text = nil

    }

    // MARK: - Public -

    public func configure(show: Show) {
        let showImageUrl = APIManager.createImageURL(withResource: show.imageURL)
        _showImageView.kf.setImage(with: showImageUrl)
        _showTitleLabel.text = show.title
    }

}
