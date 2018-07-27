//
//  ShowImageTableViewCell.swift
//  TVShows
//
//  Created by Jure Cular on 24/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class ShowImageTableViewCell: UITableViewCell {

    // MARK: - IBOutlets -

    @IBOutlet private weak var _showImageView: UIImageView!

    // MARK: - Lifecycle -

    override func prepareForReuse() {
        super.prepareForReuse()
        _showImageView.image = nil
    }

    // MARK: - Public -

    public func configure(image: UIImage) {
        _showImageView.image = image
    }
    
}
