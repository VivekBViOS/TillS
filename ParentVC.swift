//
//  ParentVC.swift
//  Till
//
//  Created by VB on 09/04/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class ParentVC: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func btnBackTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - SVProgressHUD Methods
    func showProgressHUD() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
    }
    
    func hideProgressHUD() {
        
        SVProgressHUD.dismiss()
    }
    
    //MARK: - UserDefault Methods
    func saveInUserDefault(withValue value: Any, andKey key: String) {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getFromUserDefaults(withKey key: String) -> Any? {
        
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        } else { return nil }
    }
    
    func saveBoolInUserDefults(withValue value: Bool, andKey key: String) {
        
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getBoolFromUserDefults(withKey key: String) -> Bool {
        
        let data = UserDefaults.standard.bool(forKey: key)
        return data
    }
    
    //MARK: - Alert Methods
    func showAlertFromController(withMessage message:String) {
        
        TillUtil.showAlertFromController(controller: self, withMessage: message)
    }
    
    func showAlertFromController(withMessage message:String, andHandler handler:((UIAlertAction) -> Void)?) {
        
        TillUtil.showAlertFromController(controller: self, withMessage: message, andHandler: handler)
    }

    
    
}
