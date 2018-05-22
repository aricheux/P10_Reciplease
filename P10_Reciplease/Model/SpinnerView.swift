//
//  SpinnerView.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 06/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import Foundation
import UIKit

/// Class to handle the spinner view
class SpinnerView {
    /// A view who contain all spinner view
    let loadingView = UIView()
    /// a UIActivityIndicatorView
    let spinner = UIActivityIndicatorView()
    /// A label with loading text
    let loadingLabel = UILabel()
    
    /// Set the activity indicator into the main view
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - navigationController: <#navigationController description#>
    func setLoadingScreen(tableView: UITableView, navigationController: UINavigationController?) {
        if let nav = navigationController {
            let width: CGFloat = 120
            let height: CGFloat = 30
            let x = (tableView.frame.width / 2) - (width / 2)
            let y = (tableView.frame.height / 2) - (height / 2) - (nav.navigationBar.frame.height)
            loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
            
            loadingLabel.textColor = .white
            loadingLabel.textAlignment = .center
            loadingLabel.text = "Loading..."
            loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
            
            spinner.activityIndicatorViewStyle = .white
            spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            spinner.startAnimating()
            
            loadingView.addSubview(spinner)
            loadingView.addSubview(loadingLabel)
            tableView.addSubview(loadingView)
        }
    }
    
    ///
    func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
    
}
