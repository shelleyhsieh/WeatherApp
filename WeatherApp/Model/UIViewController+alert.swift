//
//  UIViewController+alert.swift
//  TodoListApp
//
//  Created by shelley on 2023/2/14.
//

import Foundation
import UIKit

extension UIViewController {
    func oneBtnAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
