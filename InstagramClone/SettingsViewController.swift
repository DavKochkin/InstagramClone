//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by David Kochkin on 14.03.2024.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    @IBAction func logoutClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
}
