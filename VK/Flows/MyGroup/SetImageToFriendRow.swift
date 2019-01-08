//
//  SetImageToFriendRow.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class SetImageToGroupRow: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: MyGroupTableViewCell?
    
    init(cell: MyGroupTableViewCell,
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
            cell.groupImage.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.groupImage.image = image
        }
    }
}
