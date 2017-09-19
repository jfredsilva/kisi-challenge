//
//  TabBarController.swift
//  kisi.challenge
//
//  Created by Fred Silva on 18/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileController = ProfileViewController()
        
        let navigationBar = UINavigationController(rootViewController: profileController)
        navigationBar.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 1)
        
        self.viewControllers?.append(navigationBar)
    }
}
