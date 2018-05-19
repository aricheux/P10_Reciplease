//
//  MessagePopUp.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 07/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

enum PopUpChoice {
    case OkPushed, RetryPushed, CancelPushed
}

enum PopUpType {
    case OkButton, RetryButton
}

class MessagePopUp {
    static let sharedInstance = MessagePopUp()
    
    func showMessageWith(_ title: String, _ message: String, _ viewController: UIViewController, _ typeButton: PopUpType, completion: @escaping (PopUpChoice) -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.view.tintColor = UIColor.black
        
        if typeButton == .OkButton {
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default){ _ in
                completion(.OkPushed)
            })
        } else {
            alertVC.addAction(UIAlertAction(title: "Réessayer", style: .default){ _ in
                completion(.RetryPushed)
            })
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .destructive){ _ in
                completion(.CancelPushed)
            })
        }
        
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
