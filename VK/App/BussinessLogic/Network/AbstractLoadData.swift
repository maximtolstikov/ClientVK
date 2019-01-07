//
//  AbstractLoadData.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//
import Foundation

protocol AbstractLoadData: ApiManager {
    
    init(sessionConfiguration: URLSessionConfiguration)
    init()
    
    func load(completionHandler: @escaping () -> Void)
}
