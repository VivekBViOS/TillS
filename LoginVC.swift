//
//  LoginVC.swift
//  Till
//
//  Created by VB on 08/04/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class LoginVC: ParentVC
{
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewStack: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    var isRedirected:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        prepareView()
    }
    
    func prepareView()
    {
        
        TillGlobalObject.prepareTextViews(viewText: viewEmail)
        TillGlobalObject.prepareTextViews(viewText: viewPassword)
        
        btnSignIn.layer.cornerRadius = 4
        
        txtEmail.setDynamicFont()
        txtPassword.setDynamicFont()
        
        btnSkip.setDynamicFont()
        btnCreateAccount.setDynamicFont()
        
        lblLogin.setDynamicFont()
        
        if(isRedirected)
        {
            btnBack.isHidden = true
        }
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        btnSignIn.dropShadow(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.10), opacity:0.5, offSet: CGSize(width: 0, height: 10), radius: 4, scale: true)
        
        viewStack.dropShadow(color: .TillShadowColor, opacity: 0.06, offSet: CGSize(width: 0, height: -2), radius: 2, scale: true)
    }
    
    // MARK:- Helper Methods
    func Validate() -> Bool {
        let Emailresult = txtEmail.validate(BVValidationType: .email)
        let resultPassword = txtPassword.validate(BVValidationType: .password)
        
        if (Emailresult == .blank){
            TillUtil.showAlertFromController(controller: self, withMessage: TillText.ValidationMessage.EmailUsernameEmpty)
            return false
        }
        
        if (resultPassword == .blank){
            TillUtil.showAlertFromController(controller: self, withMessage: TillText.ValidationMessage.PasswordEmpty)
            return false
        }
        
        if (resultPassword == .invalid){
            TillUtil.showAlertFromController(controller: self, withMessage: TillText.ValidationMessage.PasswordNotValid)
            return false
        }
        return true
    }
    
    //MARK: - User Interaction
    @IBAction func btnForgetTap(_ sender: Any)
    {
        let vcForget:ForgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vcForget, animated: true)
        
    }
    
    @IBAction func btnCreateTap(_ sender: Any)
    {
        let vcRegistration:RegistrationInputVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationInputVC") as! RegistrationInputVC
        self.navigationController?.pushViewController(vcRegistration, animated: true)
    }
    
    @IBAction func btnSignInTap(_ sender: Any)
    {
        if(Validate())
        {
            guard TillUtil.reachable() else {

                showAlertFromController(withMessage: TillText.AppMessages.NoInternet)
                return
            }
            
            let parameter = [TillAPI.RQKey.RQKeyEmail          : txtEmail.text!.trimmed,
                             TillAPI.RQKey.RQKeyPassword       : txtPassword.text!,
                             TillAPI.RQKey.RQKeyPlatform       : TillGlobalObject.ApplicationPlatform,
                             TillAPI.RQKey.RQKeyrole           : TillGlobalObject.Role
                ] as [String: Any]
            
            showProgressHUD()
            
            TillWebServiceAPI.userLogin(parameter) { (userInfo, response) in
                
                self.hideProgressHUD()
                
                if(response?.meta?.status_code == TillAPI.RCode.Success)
                {
                    TillGlobalObject.setUpNotification(application: UIApplication.shared)
                    TillGlobalObject.user = userInfo
                    TillGlobalObject.user?.signIn()
                    
                    TillUtil.SetupSideMenu()
                    
                    if(TillGlobalObject.user?.subscriptionPackID != "1")
                    {
                        TillGlobalObject.CheckForValidation()
                    }
                    
                    return
                    
                   
                    
                    if(userInfo!.isEmailVerified == false)
                    {
                        TillUtil.showTwoAlertFromController(controller: self, withMessage: TillMessage.EmailVerification, andHandler: { (okAction) in
                            
                        }, andSecondHandler: { (resendAction) in
                            TillGlobalObject.resendVerificationMail()
                        }, firstButtonTitle: "Ok", secondButtonTitle: "Resend")
                    
                    }
                    else{
                        TillGlobalObject.setUpNotification(application: UIApplication.shared)
                        TillGlobalObject.user = userInfo
                        TillGlobalObject.user?.signIn()
                        
                        TillUtil.SetupSideMenu()
                    }
//
                }
                else
                {
                    self.showAlertFromController(withMessage: response?.meta?.message ?? TillText.AppMessages.SomethingWentWrong)
                }
        
            }
            
        }
        
    }
    
    @IBAction func btnSkipForNowTap(_ sender: Any) {
        TillUtil.SetupSideMenu()
        
    }
}
