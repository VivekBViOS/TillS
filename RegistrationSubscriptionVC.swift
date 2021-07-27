//
//  RegistrationSubscriptionVC.swift
//  Till
//
//  Created by VB on 16/04/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MapKit

class RegistrationSubscriptionVC: ParentVC, UITableViewDelegate, UITableViewDataSource {
    
    var parameters:[String : Any]?
    
    @IBOutlet weak var tblvSubscription: UITableView!
    var arrPackageInfo:[TillPlans]?
    
    @IBOutlet weak var btnContinue: UIButton!
    
    var selectedPlan:TillPlans?
    
    //MARK: UIViewController Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        GetSubscriptionPlan()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        btnContinue.layer.cornerRadius = 5
        
        btnContinue.dropShadow(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.10), opacity:0.5, offSet: CGSize(width: 0, height: 10), radius: 4, scale: true)
    }
    
    
    //MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (arrPackageInfo?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            let infoCell:SubscriptionInfoCell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionInfoCell") as! SubscriptionInfoCell
            return infoCell
        }
        else
        {
            let packageCell:PackageInfoCell = tableView.dequeueReusableCell(withIdentifier: "PackageInfoCell", for: indexPath) as! PackageInfoCell
            
            let planDetail:TillPlans = arrPackageInfo![indexPath.row - 1]
            
            packageCell.setuppackageDetail(planDetail: planDetail)
            
            return packageCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            return
        }
        else{
            let planDetail:TillPlans = arrPackageInfo![indexPath.row - 1]
            
            for planInfo:TillPlans in arrPackageInfo!
            {
                if(planInfo.ID == planDetail.ID)
                {
                    planInfo.isSelected = true
                    selectedPlan = planInfo
                }
                else{
                    planInfo.isSelected = false
                }
            }
            
            tblvSubscription.reloadData()
        }
    }
    
    //MARK: User Interaction Methods
    @IBAction func btnContinueTap(_ sender: Any)
    {
        if(selectedPlan == nil)
        {
        self.showAlertFromController(withMessage:TillText.ValidationMessage.SelectMembershipPlan)
            return
        }
        let vcReview:RegistrationReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationReviewVC") as! RegistrationReviewVC
        vcReview.parameter = parameters
        vcReview.selectedPlan = selectedPlan
        self.navigationController?.pushViewController(vcReview, animated: true)
    }
    
    //MARK: Helper Methods
    func GetSubscriptionPlan()
    {
        guard TillUtil.reachable() else
        {
            showAlertFromController(withMessage: TillText.AppMessages.NoInternet)
            return
        }
        
        self.showProgressHUD()
        
        TillWebServiceAPI.GetSubscriptionPlans(nil) { (plans, response) in
            
            self.hideProgressHUD()
            
            if(response?.meta?.status_code == TillAPI.RCode.Success)
            {
                self.arrPackageInfo = plans
                self.tblvSubscription.reloadData()
            }
            else{
                self.showAlertFromController(withMessage: (response?.meta?.message)!)
            }
        }
    }
}
