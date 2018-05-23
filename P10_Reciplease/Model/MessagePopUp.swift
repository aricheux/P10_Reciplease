//
//  MessagePopUp.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 07/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

/// Enumeration to know the user choice in the UIAlertController
///
/// - OkPushed: Button ok is pushed
/// - RetryPushed: Button retry is push
/// - CancelPushed: Button cancel is push
enum PopUpChoice {
    case OkPushed, RetryPushed, CancelPushed
}

/// Enumeration to define component of the UIAlertController
///
/// - OkButton: Ok button is added in the UIAlertController
/// - RetryButton: Retry and Cancel button are added in the UIAlertController
enum PopUpType {
    case OkButton, RetryButton
}

/// Class to handle the message pop-up
class MessagePopUp {
    /// Singleton to share the RecipeManager to all project
    static let sharedInstance = MessagePopUp()

    /// Define the UIAlertController and present it in the viewController
    ///
    /// - Parameters:
    ///   - title: title of the UIAlert
    ///   - message: Message of the UIAlert
    ///   - viewController: viewController to show the UIAlert
    ///   - typeButton: define the button of the UIAlert
    ///   - completion: return which button is pushed
    func showMessageWith(_ title: String, _ message: String, _ viewController: UIViewController, _ typeButton: PopUpType, completion: @escaping (PopUpChoice) -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.view.tintColor = #colorLiteral(red: 0.2784313725, green: 0.5803921569, blue: 0.3725490196, alpha: 1)
        
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
