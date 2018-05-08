//
//  MessagePopUp.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 07/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

class MessagePopUp {
    
    var message: String
    var title: String
    var viewController: UIViewController
    
    init(_ title: String, _ message: String, _ viewController: UIViewController) {
        self.message = message
        self.title = title
        self.viewController = viewController
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.view.tintColor = UIColor.black
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel){ (action:UIAlertAction!) in
            viewController.navigationController?.popViewController(animated: true)
        })
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
