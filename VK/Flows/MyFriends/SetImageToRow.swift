//
//  SetImageToRow.swift
//  VK
//
//  Created by Maxim Tolstikov on 05/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class SetImageToRow: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: MyFriendsTableViewCell?
    
    init(cell: MyFriendsTableViewCell,
         indexPath: IndexPath,
         tableView: UITableView) {
        
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return}
        
        if let newIndexPath = tableView.indexPath(for: cell),
            newIndexPath == indexPath {
            cell.avatarImage.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.avatarImage.image = image
        }
    }
}
