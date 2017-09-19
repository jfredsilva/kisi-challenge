//
//  UIImageViewExtension.swift
//  kisi.challenge
//
//  Created by Fred Silva on 18/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRoundImageContainer() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
