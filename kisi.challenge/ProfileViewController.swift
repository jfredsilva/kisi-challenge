//
//  ProfileViewController.swift
//  kisi.challenge
//
//  Created by Fred Silva on 18/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate let backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    fileprivate let blueCellColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
    
    fileprivate let image = UIImageView(image: UIImage(named: "profile-pic"))
    fileprivate let name = UILabel()
    fileprivate let email = UILabel()
    fileprivate let table = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        self.table.register(CustomDefaultTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        self.setUI()
        self.setConstraints()
        self.view.backgroundColor = backgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.image.setRoundImageContainer()
    }
    
    private func setUI(){
        self.title = "Profile"
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.view.addSubview(self.image)
        self.image.translatesAutoresizingMaskIntoConstraints = false
        self.image.backgroundColor = UIColor.white
        self.image.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.name)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.name.textAlignment = .center
        self.name.text = "Fred Silva"
        self.name.font = self.name.font.withSize(18)
        
        self.view.addSubview(self.email)
        self.email.translatesAutoresizingMaskIntoConstraints = false
        self.email.textAlignment = .center
        self.email.text = "jfredsilva@gmail.com"
        self.email.font = self.email.font.withSize(12)
        
        self.view.addSubview(self.table)
        self.table.translatesAutoresizingMaskIntoConstraints = false
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    private func setConstraints(){
        self.image.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.name.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 20).isActive = true
        self.name.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        self.name.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        self.email.topAnchor.constraint(equalTo: self.name.bottomAnchor, constant: 5).isActive = true
        self.email.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        self.email.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        self.table.topAnchor.constraint(equalTo: self.email.bottomAnchor, constant: 0).isActive = true
        self.table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "DefaultCell")
            
            switch indexPath.row{
            case 0:
                cell.textLabel!.text = "Name, Phone Numbers, Email"
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel!.text = "Password & Security"
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.textLabel!.text = "Payment & Shipping"
                cell.accessoryType = .disclosureIndicator
            default:
                print("Invalid row")
            }
            
            return cell
        }else{
            let cell = CustomDefaultTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CustomCell")
            
            switch indexPath.row{
            case 0:
                cell.textLabel!.text = "iCloud"
                cell.imageView?.image = UIImage(named: "icloud")
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel!.text = "iTunes & App Store"
                cell.imageView?.image = UIImage(named: "appstore")
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.textLabel!.text = "Set Up Family Sharing..."
                cell.imageView?.image = UIImage(named: "family-sharing")
                cell.textLabel?.textColor = blueCellColor
            default:
                print("Invalid row")
            }

            return cell
        }
    }
}
