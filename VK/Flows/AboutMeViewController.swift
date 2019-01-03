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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    
    let service = LoadUserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchUserData { [weak self] (result) in
            switch result {
            case .Success(let user):
                self?.updateDataFor(user: user)
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateDataFor(user: User) {
        
        nameLable.text = user.fullName
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        controller.logout()
        present(controller, animated: true, completion: nil)
    }
    
}
