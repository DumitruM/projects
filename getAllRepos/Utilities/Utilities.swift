//
//  Utilities.swift
//  getAllRepos
//
//  Created by Mihai Dumitru on 07/03/2019.
//  Copyright © 2019 Mihai Dumitru. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func showAlertController(title : String?, message : String?, preferredStyle : UIAlertController.Style, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for action in actions {
            alertController.addAction(action)
        }

        present(alertController, animated: true, completion: nil)
    }
}

