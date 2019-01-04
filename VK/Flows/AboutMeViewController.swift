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
    
    let service = LoadUserData()
    var token: NotificationToken?
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
    }
    
    private func updateData() {
        
        guard let idUser = VKSdk.accessToken()?.localUser.id.stringValue else { return }
        
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "id = %@", idUser)
            let result = realm.objects(User.self).filter(predicate)
            token = result.observe({ [weak self] (change) in
                switch change {
                case .update:
                    guard let user = result.first else { return }
                    self?.nameLable.text = user.fullName
                    self?.token = nil
                default: break
                }
            })
            
            if let user = result.first {
                
                nameLable.text = user.fullName
                
                let getCacheImage = GetCacheImage(url: user.photo)
                getCacheImage.completionBlock = {
                    OperationQueue.main.addOperation {
                        self.imageView.image = getCacheImage.outputImage
                    }
                }
                queue.addOperation(getCacheImage)
                
            } else {
                service.load()
            }
            
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        let controller = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        controller.logout()
        present(controller, animated: true, completion: nil)
    }
    
}
