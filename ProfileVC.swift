//
//  ProfileVC.swift
//  Till
//
//  Created by VR on 21/05/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

enum PROFILETYPE : String{
    case Own = "Own"
    case Other = "Other"
}

class ProfileVC: TabParentVC,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblTokenValue: UILabel!
    @IBOutlet weak var lblNavTitle : UILabel!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnSideMenu : UIButton!
    @IBOutlet weak var viewTopBar: UIView!
    @IBOutlet weak var colProfile: UICollectionView!
    
    var strScreenType = PROFILETYPE.Own
    var totalPostCount = "0"
    var strUserId = String()
    var strUserName = String()
    
    var totalRecords:NSNumber = 0
    var pageN:NSNumber = 1
    var arrMedia = [TillPost]()
    var user: TillUser?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setTokenvalue()

        setUpCell()
        setUI()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if strScreenType == PROFILETYPE.Own
        {
            self.prepareView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCall()
    }
    
    //MARK:- UI Methods
    func setUI() {
        if strScreenType == PROFILETYPE.Own{
            lblNavTitle.text = "My Profile"
            btnBack.isHidden = true
            btnSideMenu.isHidden = false
            self.selectedIndex = 5
        }else{
            lblNavTitle.text = "Profile"
            btnBack.isHidden = false
            btnSideMenu.isHidden = true
        }
    }
    
    func apiCall()  {
        if strScreenType == PROFILETYPE.Own{
            self.GetProfile(id: TillGlobalObject.user?.id ?? "", username: TillGlobalObject.user?.userName ?? "")
        }else{
             self.GetProfile(id: strUserId, username: strUserName)
        }
    }
    
    func prepareView()
    {
        viewTopBar.dropShadow(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.20), opacity:0.8, offSet: CGSize(width: 0, height: 3), radius: 2, scale: true)
    }
    
    //MARK:- Custom Methods
    func setUpCell()  {
        self.colProfile.register(UINib.init(nibName: "ProfileCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCell")
        self.colProfile.register(UINib(nibName: "PhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionCell")
        self.colProfile.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        self.colProfile.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"HeaderView")
    }
    
    func setupPagination(){
        pageN = 1
        colProfile.addInfiniteScrolling
            {
                if(self.arrMedia.count < self.totalRecords.intValue)
                {
                    self.pageN = NSNumber.init( value: self.pageN.int32Value + 1)
                    self.GetPostsList(userId: self.strUserId)
                }
                else
                {
                    self.colProfile.infiniteScrollingView.stopAnimating()
                }
        }
        self.showProgressHUD()
        self.GetPostsList(userId: strUserId)
    }
   
    func setTokenvalue() {
        
        TillGlobalObject.GetTokenList() { (detail)  in
            //Total Current Token
            self.lblTokenValue.text = detail.total_current_token
        }
    }
    
    //MARK:- UICollectionView datasource and delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if Int(totalPostCount)! == 0{
                if self.strScreenType == PROFILETYPE.Own{
                    return 1
                }else{
                    return 1
                }
            }else{
                return arrMedia.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = colProfile.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            
            if strScreenType == PROFILETYPE.Own{
                cell.btnEditProfile.isHidden = false
            }else{
                cell.btnEditProfile.isHidden = true
            }
            
            cell.indexPath = indexPath
            if user != nil{
                cell.objProfile = user
            }
            
            return cell
            
        }else{
            if Int(totalPostCount)! == 0{
                if self.strScreenType == PROFILETYPE.Own{
                    let cell:PostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
                    cell.viewNoData.isHidden = true
                    cell.mainView.isHidden = false
                    return cell
                }else{
                    let cell:PostCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
                    cell.viewNoData.isHidden = false
                    cell.mainView.isHidden = true
                    return cell
                }
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
                cell.indexPath = indexPath
                cell.objMedia = self.arrMedia[indexPath.row]
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0{
            let cell = colProfile.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            let aboutHeight = TillGlobalObject.heightForView(text: (self.user?.aboutUs) ?? "", font: UIFont.init(name: AppFontWSLight, size: cell.lblAboutBio.font.pointSize)!, width: cell.lblAboutBio.bounds.width)
//            cell.consAboutHeight.constant = aboutHeight
//            cell.consHeight.constant = aboutHeight + 39.0 + 20.0
            
            let height = cell.profileView.frame.height + cell.followersView.frame.height + (aboutHeight + 39 + 20)
            return CGSize(width: collectionView.frame.size.width, height: height)
        }else{
            if Int(totalPostCount)! == 0{
                if self.strScreenType == PROFILETYPE.Own{
                   return CGSize(width: (collectionView.frame.width-40), height: 226.0)
                }else{
                     return CGSize(width: (collectionView.frame.width-40), height: 226.0)
                }
            }else{
                //let height = (TillGlobalObject.ScreenHeight * 226.0) / 375 130 64
                let height = ((((collectionView.frame.width-40)/3)-3) * 64) / 110
                return CGSize(width: (collectionView.frame.width-40)/3-3, height:  height)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 1{
            switch kind {
                
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
                
                return headerView
                
            default:
                assert(false, "Unexpected element kind")
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            if section == 1{
                return CGSize(width: collectionView.frame.width, height: 50.0)
            }
            return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            if(self.arrMedia.count > 0){
            let postDetail:PostDetailVC = TillGlobalObject.mainStoryboard.instantiateViewController(withIdentifier: "PostDetailVC") as! PostDetailVC
            postDetail.arrPosts = self.arrMedia
            postDetail.postIndex = indexPath
            postDetail.postType = ListingTypeUsersPost
            postDetail.pageN = self.pageN
            postDetail.userID = (self.user?.ID)!
            postDetail.totalRecords = self.totalRecords
            self.navigationController?.pushViewController(postDetail, animated: true)
            }
        }
    }
    
    //MARK:- Get Profile API Methods
    func GetProfile(id:String,username:String) {
        guard TillUtil.reachable() else{
            showAlertFromController(withMessage: TillText.AppMessages.NoInternet)
            return
        }
        let parameter = [TillAPI.RKey.ID : id,
                         TillAPI.RQKey.RQKeyUsername : username] as [String: Any]
        print(parameter)
        showProgressHUD()
        TillWebServiceAPI.GetUserProfile(parameter) { (userInfo, response) in
            
            self.hideProgressHUD()
            
            if(response?.meta?.status_code == TillAPI.RCode.Success)
            {
                self.user = userInfo
                self.totalPostCount = self.user?.totalPosts ?? "0"
                
//                TillGlobalObject.user = userInfo
                
                if Int(self.totalPostCount)! > 0{
                    if self.strScreenType == PROFILETYPE.Own{
                        self.strUserId = TillGlobalObject.user?.id ?? ""
                    }else{
                        self.strUserId = userInfo?.ID ?? ""
                    }
                    self.arrMedia.removeAll()
                    self.arrMedia = [TillPost]()
                    //call posts api
                    self.setupPagination()
                }else{
                    self.colProfile.addNoDataViewWithMessage(message: TillText.AppMessages.NoDataFound)
                }
                self.colProfile.reloadData()
            }
            else
            {
//                self.showAlertFromController(withMessage: response?.meta?.message ?? TillText.AppMessages.SomethingWentWrong)
                self.showAlertFromController(withMessage: response?.meta?.message ?? TillText.AppMessages.SomethingWentWrong, andHandler: { (okAction) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        }
    }
    
    //MARK:- API Methods
    func GetPostsList(userId:String)
    {
        guard TillUtil.reachable() else {
            
            showAlertFromController(withMessage: TillText.AppMessages.NoInternet)
            self.hideProgressHUD()
            return
        }
        
        let parameter = [
            "page_no" : pageN,
            TillAPI.RQKey.RQkeyUserId : userId,
            "length" : 15
            ] as [String:Any]
        
        TillWebServiceAPI.GetPostList(parameter) { (posts, response, totalItems) in
            self.hideProgressHUD()
            
            self.colProfile.infiniteScrollingView.stopAnimating()
            
            if(self.arrMedia.count == 0)
            {
                if(posts?.count == 0)
                {
                    self.colProfile.addNoDataViewWithMessage(message: TillText.AppMessages.NoDataFound)
                }
                else
                {
                    self.arrMedia = posts!
                    self.colProfile.backgroundView = nil
                }
            }
            else
            {
                self.arrMedia.append(contentsOf: posts!)
                self.colProfile.backgroundView = nil
            }
            
            self.totalRecords = NSNumber.init(value: totalItems)
            self.colProfile.reloadData()
        }
    }
}


