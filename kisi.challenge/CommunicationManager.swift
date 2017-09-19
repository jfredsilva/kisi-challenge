//
//  CommunicationManager.swift
//  kisi.challenge
//
//  Created by Fred Silva on 18/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit

class CommunicationManager: NSObject {
    fileprivate let endpoint = "https://api.getkisi.com/locks/5124/access"
    
    static let sharedInstance = CommunicationManager()
    
    func openDoor(onCompletion: @escaping (Bool) -> Void) {
        guard let url = URL(string: endpoint) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
            
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                print(error!.localizedDescription)
                onCompletion(false)
            }
            
            onCompletion(true)
            })

        task.resume()
    }
}
