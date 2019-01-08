//
//  MyGroupTableViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class MyGroupsTableViewController: UITableViewController {
    
    var service: AbstractLoadData?
    var realm: AbstractRealmManager?
    var groups = [Group]()
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
        
        let predicate = NSPredicate(value: true)
        
        guard let realm = realm,
            let result = realm.loadDataBy(type: Group.self,
                                          predicate: predicate) else { return }
        
        groups = Array(result)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupTableViewCell", for: indexPath) as! MyGroupTableViewCell

        cell.nameLable.text = groups[indexPath.row].name
        
        let urlPhoto = groups[indexPath.row].photo50
        let getCacheImage = GetCacheImage(url: urlPhoto)
        let setImageToRow = SetImageToGroupRow(cell: cell,
                                          indexPath: indexPath,
                                          tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)

        return cell
    }

}
