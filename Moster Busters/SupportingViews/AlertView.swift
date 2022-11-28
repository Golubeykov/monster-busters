//
//  AlertView.swift
//  Moster Busters
//
//  Created by Антон Голубейков on 28.11.2022.
//

import UIKit

enum AlertView {

    static func appendRequiredActionAlertView(textBody: String, textAction: String, completion: @escaping (UIAlertAction) -> Void) {
        guard let topViewController = UIApplication.getTopViewController() else { return }

        let alert = UIAlertController(title: "Внимание", message: textBody, preferredStyle: UIAlertController.Style.alert)
        let confirmAction = UIAlertAction(title: textAction, style: UIAlertAction.Style.default, handler: completion)
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        alert.preferredAction = confirmAction

        topViewController.present(alert, animated: true, completion: nil)
    }

}
