//
//  MyFriendsTableViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import RealmSwift
import UIKit
import VK_ios_sdk

class MyFriendsTableViewController: UITableViewController {
    
    var service: AbstractLoadData?
    var realm: AbstractRealmManager?
    var friends = [User]()
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service?.load {
            self.updateData()
        }        
    }
    
    private func updateData() {
        
        guard let idUser = VKSdk.accessToken()?.localUser.id.stringValue else { return }

        let predicate = NSPredicate(format: "id != %@", idUser)
   
        guard let realm = realm,
            let result = realm.loadDataBy(type: User.self,
                                                 predicate: predicate) else { return }
        
        friends = Array(result)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as! MyFriendsTableViewCell
        
        cell.nameLable.text = friends[indexPath.row].fullName
        
        let urlPhoto = friends[indexPath.row].photo50
        let getCacheImage = GetCacheImage(url: urlPhoto)
        let setImageToRow = SetImageToRow(cell: cell,
                                          indexPath: indexPath,
                                          tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as? FriendViewController
                controller?.user = friends[indexPath.row]
            }
        }
    }
    
    
}
