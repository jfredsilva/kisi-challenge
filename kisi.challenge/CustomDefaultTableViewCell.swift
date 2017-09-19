//
//  CustomDefaultTableViewCell.swift
//  kisi.challenge
//
//  Created by Fred Silva on 18/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit

//Custom cell to implement a fixed imageview cell
class CustomDefaultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.frame = CGRect(x: 10, y: 0, width: 40, height: 40)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
