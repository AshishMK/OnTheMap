//
//  AlertController.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/5/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
import UIKit
class AlertController {
    
    class func showAlert(_ title: String,message: String, completion: ((UIAlertAction)-> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        if let topController = UIApplication.topViewController() {
            topController.present(alertVC,animated: true, completion: nil)
        }
    }
}
