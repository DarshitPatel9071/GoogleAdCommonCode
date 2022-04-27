//
//  CommonExtension.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import UIKit

extension UIApplication
{
    class func getTopMostVC(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return getTopMostVC(base: nav.visibleViewController)
        }
        else if let tab = base as? UITabBarController, let selected = tab.selectedViewController
        {
            return getTopMostVC(base: selected)
        }
        else if let presented = base?.presentedViewController
        {
            return getTopMostVC(base: presented)
        }
        
        return base
    }
    
}

extension UIViewController
{
    func alertWith(title:String,message: String, cancelTitle:String,  othersTitle: [String] = [], cancelTap:(()->())? = nil, othersTap: ((_ index: Int, _ title: String)->())? = nil)
    {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if othersTitle .count > 0
        {
            for (index, str) in othersTitle.enumerated()
            {
                alert.addAction(UIAlertAction(title: str, style: .default, handler: { (action) in
                    othersTap?(index, str)
                }))
            }
        }
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action) in
            cancelTap?()
        }))
        
        DispatchQueue.main.async
        {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
