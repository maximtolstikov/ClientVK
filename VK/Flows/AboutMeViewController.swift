//
//  AboutMeViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 26/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import RealmSwift
import UIKit
import VK_ios_sdk

class AboutMeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    
    var service: AbstractLoadData?
    var realm: AbstractRealmManager?
    var token: NotificationToken?
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    private func loadData() {
        
        guard let idUser = VKSdk.accessToken()?.localUser.id.stringValue else { return }
        let predicate = NSPredicate(format: "id = %@", idUser)
        guard let realmManager = realm,
            let result = realmManager.loadDataBy(type: User.self,
                                                   predicate: predicate) else { return }
        
        token = result.observe({ [weak self] (change) in
            switch change {
            case .update:
                guard let user = result.first else { return }
                self?.updateData(user: user)
                self?.token = nil
            default: break
            }
        })
        
        if let user = result.first {
            updateData(user: user)
        } else {
            service?.load {}
        }
    }
    
    private func updateData(user: User) {
        nameLable.text = user.fullName
        
        let getCacheImage = GetCacheImage(url: user.photo200)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                self.imageView.image = getCacheImage.outputImage
            }
        }
        queue.addOperation(getCacheImage)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        controller.logout()
        present(controller, animated: true, completion: nil)
    }
    
}
