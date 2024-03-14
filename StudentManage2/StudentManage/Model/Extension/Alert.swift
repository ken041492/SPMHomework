//
//  Alert.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/3.
//

import Foundation
import UIKit

class Alert {
    
    func showAlert(title: String,
                   message: String,
                   vc: UIViewController,
                   okActionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            okActionHandler?() // 执行传递的闭包，如果存在的话
        }
        alertController.addAction(okAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showInputAlert(vc: UIViewController,
                        title: String?,
                        message: String?,
                        placeholders: [String], // 用数组来存放占位文本
                        onCancel: (() -> Void)? = nil,
                        onConfirm: (([String]) -> Void)? = nil) { // onConfirm现在接收String数组
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for placeholder in placeholders {
            alertController.addTextField { (textField) in
                textField.placeholder = placeholder
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            onCancel?()
        }

        alertController.addAction(cancelAction)

        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { _ in
            /// 尋找 alertController 裡的所有 textfield
            let inputTexts = alertController.textFields?.compactMap { $0.text } ?? []
                onConfirm?(inputTexts)
            }

        alertController.addAction(confirmAction)

        vc.present(alertController, animated: true, completion: nil)
    }

}
