//
//  MessagePopUp.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 07/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

enum PopUpChoice {
    case OkPushed, CancelPushed
}

class MessagePopUp {
    static let sharedInstance = MessagePopUp()
    
    func showMessageWith(_ title: String, _ message: String, _ viewController: UIViewController, completion: @escaping (PopUpChoice) -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.view.tintColor = UIColor.black
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel){ _ in
            completion(.OkPushed)
        })
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
