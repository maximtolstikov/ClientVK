//
//  AboutMeViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 26/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class AboutMeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        controller.logout()
        present(controller, animated: true, completion: nil)
    }
    
}
