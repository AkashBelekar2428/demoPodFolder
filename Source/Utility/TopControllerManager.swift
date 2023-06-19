//
//  TopController.swift
//  MFUIAthentication
//
//  Created by Akash Belekar on 30/05/23.
//

import Foundation
import UIKit

//MARK: TopControllerManager Class
public class TopControllerManager {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

