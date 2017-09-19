//
//  ViewController.swift
//  kisi.challenge
//
//  Created by Fred Silva on 13/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func senderAction(_ sender: Any) {
        let viewController = SenderViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func receiverAction(_ sender: Any) {
        let viewController = ReceiverViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

