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
    
    let service = LoadMyData()
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
        
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL?.absoluteString ?? "")
            let predicate = NSPredicate(format: "id = %@", idUser)
            let result = realm.objects(User.self).filter(predicate)
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
                service.load()
            }
            
        } catch (let error) {
            print(error.localizedDescription)
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
        
        // TODO: - сделать отчистку Realm
    }
    
}
