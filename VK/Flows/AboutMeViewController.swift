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

        VKSdk.forceLogout()
    }

}
