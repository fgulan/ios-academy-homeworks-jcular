//
//  ShowTableViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 18/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit
import Kingfisher

class ShowGridCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _showImageView: UIImageView!

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _showImageView.image = nil
    }

    // MARK: - Public -

    public func configure(show: Show) {
        let showImageUrl = APIManager.createImageURL(withResource: show.imageURL)
        _showImageView.kf.setImage(with: showImageUrl)
    }

}
