//
//  AvatarView.swift
//  VK
//
//  Created by Maxim Tolstikov on 06/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class AvatarView: UIImageView {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2.0
        clipsToBounds = true
    }
}
