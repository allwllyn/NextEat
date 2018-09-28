//
//  UIViewControllerExt.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/28/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    
    
   
    func formatAlert(_ alert: UIAlertController)
    {
        if alert.actions.count == 0
        {
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        self.present(alert, animated: true)
    }


}
