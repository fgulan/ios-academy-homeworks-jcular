//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Jure Cular on 26/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import UIKit

class AddEpisodeViewController: UIViewController {
    // MARK: - IBOutlets -

    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _episodeTitleTextField: UITextField!
    @IBOutlet weak var _seasonNumberTextField: UITextField!
    @IBOutlet weak var _episodeNumberTextField: UITextField!
    @IBOutlet weak var _episodeDescriptionTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

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

    }

}
