//
//  FriendViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {
    
    var user: User?
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setPhoto()
    }
    
    private func setPhoto() {
        
        guard let user = user else { return }
        
        let getCacheImage = GetCacheImage(url: user.photo400)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                self.image.image = getCacheImage.outputImage
            }
        }
        queue.addOperation(getCacheImage)
    }

}
