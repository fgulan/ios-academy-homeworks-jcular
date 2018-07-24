//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Jure Cular on 24/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {

    // MARK: - Private properties -

    private var _token: String?
    private var _showID: String?

    // MARK: - Init -

    public class func initFromStoryboard(withToken token: String, showID: String) -> ShowDetailsViewController {
        let showDetailsStoryboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = showDetailsStoryboard.instantiateInitialViewController() as! ShowDetailsViewController
        showDetailsViewController._token = token
        showDetailsViewController._showID = showID


        return showDetailsViewController
    }

}
