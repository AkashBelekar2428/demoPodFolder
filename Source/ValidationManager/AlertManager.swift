//
//  AlertManager.swift
//  MFUIAthentication
//
//  Created by Akash Belekar on 29/05/23.
//

import Foundation

public class AlertManager {
    
    //MARK: Singletone
    static public let shared = AlertManager()
    
    //MARK: Alert
    public func showAlert(title:String,msg:String,action:String,viewController:UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default,handler:{ _ in
            
        })
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
    
    //MARK: Single Action Alert
    public func showSingleAlert(title:String,msg:String,action:String,firstCompletion:@escaping () -> Void,viewController:UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: action, style: .default,handler:{ _ in
            firstCompletion()
        })
        alert.addAction(ok)
        viewController.present(alert, animated: true)
    }
    //MARK: Double Action Alert
    public func showAlertsActions(title:String, msg:String, firstAction:String, secondAction:String, firstCompletion:@escaping () -> Void,secondCompletion:@escaping () -> Void, viewController: UIViewController){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: firstAction, style: .default, handler: { _ in
            print("Ok")
            
            firstCompletion()
        })
        
        let cancle = UIAlertAction(title: secondAction, style: .cancel,handler: { _ in
            print("Cancle")
            secondCompletion()
        })
        
        alert.addAction(ok)
        alert.addAction(cancle)
        
        DispatchQueue.main.async(execute: {
            viewController.present(alert, animated: true)
        })
    }
}

