//
//  TillWebService+User.swift
//  Till
//
//  Created by VB on 06/05/19.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import SwiftyJSON

extension TillWebService{
    
    func userLogin(_ parameter:[String: Any]?, completion:@escaping (TillUser?, TillAPIResponse?) -> Void) {
        
        self.sendRequest(.logIn(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(parsedResponse.meta?.status_code == TillAPI.RCode.Success){
                        let user = TillUser(parameter: jsonResult[TillAPI.RKey.Data][UKeyUserDetail])
                        //                        user?.token = jsonResult[TillAPI.RKey.Data][UKeyToken].stringValue
                        completion(user,parsedResponse)
                    }
                    else{
                        completion(nil,parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse)
            }
        }
    }
    
    func GetUserProfile(_ parameter:[String: Any]?, completion:@escaping (TillUser?, TillAPIResponse?) -> Void) {
        
        self.sendRequest(.GetProfile(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(nil, parsedResponse)
                    }
                    else{
                        if(parsedResponse.meta?.status_code == TillAPI.RCode.Success){
                            
                            
                            let user = TillUser(parameter: jsonResult[TillAPI.RKey.Data][UKeyUserData])
                            
                            DispatchQueue.main.async {
                            completion(user,parsedResponse)
                            }
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                completion(nil,parsedResponse)
                            }
                            
                        }
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse)
            }
        }
    }
    func Updateprofile(_ parameter:[String: Any]?, completion:@escaping ( TillAPIResponse?) -> Void) {
        
        
        self.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameter! {
                
                if key == UKeyProfilepic {
                    
                    let imageData = parameter![UKeyProfilepic] as! Data
                    if imageData.count > 0 {
                        
                        multipartFormData.append(imageData, withName:UKeyProfilepic, fileName: "profile.jpg", mimeType: "image/jpg")
                    }
                } else {
                    
                    let string = value as! String
                    let data = string.data(using: String.Encoding.utf8)
                    multipartFormData.append(data!, withName: key)
                }
            }
        }, to: BaseAPIPath + "user/setProfile" ,method: .post, headers: header) { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON {response in
                    
                    if let _ = response.result.value {
                        let jsonResult: JSON = JSON(response.result.value!)
                        
                        //                        let user = TillUser(parameter: jsonResult[TillAPI.RKey.Data][UKeyUserDetail])
                        
                        let parsedResponse = TillAPIResponse(parameter: jsonResult)
                        
                        if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                            self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                            completion(parsedResponse)
                        }
                        else{
                            completion(parsedResponse)
                        }
                    }
                    else{
                        let parsedResponse = TillAPIResponse.init()
                        parsedResponse.meta?.status_code = 10000
                        parsedResponse.meta?.message = response.result.error?.localizedDescription
                        
                        completion(parsedResponse)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(nil)
            }
        }
    }
    
    func userSignUp(_ parameter:[String: Any]?, completion:@escaping (TillUser?,TillAPIResponse?) -> Void) {
        
        self.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameter! {
                
                if key == UKeyProfilepic {
                    
                    let imageData = parameter![UKeyProfilepic] as! Data
                    if imageData.count > 0 {
                        
                        multipartFormData.append(imageData, withName:UKeyProfilepic, fileName: "profile.jpg", mimeType: "image/jpg")
                    }
                } else {
                    
                    let string = value as! String
                    let data = string.data(using: String.Encoding.utf8)
                    multipartFormData.append(data!, withName: key)
                }
            }
        }, to: BaseAPIPath + "oauth/signup" ,method: .post, headers: header) { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON {response in
                    
                    if let _ = response.result.value {
                        let jsonResult: JSON = JSON(response.result.value!)
                        
                        let user = TillUser(parameter: jsonResult[TillAPI.RKey.Data][UKeyUserDetail])
                        
                        let parsedResponse = TillAPIResponse(parameter: jsonResult)
                        
                        if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                            self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                            completion(nil, parsedResponse)
                        }
                        else{
                            completion(user,parsedResponse)
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(nil,nil)
            }
        }
        
    }
    
    
    func ForgetPasswordReset(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.ForgotPSWD(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    completion(parsedResponse)
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func GetSubscriptionPlans(_ parameter:[String: Any]?, completion:@escaping ([TillPlans]? ,TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.getSubscriptionPlan, withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    let plans = (jsonResult[TillAPI.RKey.Data].to(type: TillPlans.self) ?? [] ) as! [TillPlans]
                    
                    completion(plans ,parsedResponse)
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil, parsedResponse)
            }
        }
    }
    
    func ReSendVerificationMail(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.resendVerificationMail(), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    
                    completion(parsedResponse)
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    func SendMailToReciepents(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.SendMailTorecipent(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: jsonResult["status_code"].intValue)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                    
//                    completion(parsedResponse)
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func CreatePost(_ parameter:[String: Any]?, postContents:[CreatePostContent]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        self.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameter!
            {
                let string = value as! String
                let data = string.data(using: String.Encoding.utf8)
                multipartFormData.append(data!, withName: key)
            }
            
            for (index, postContent) in postContents!.enumerated() {
                
                let thumbNailKey:String = "post_media[\(index)][thumbnail]"
                let mediaFile:String    = "post_media[\(index)][media_file]"
                
                if(postContent.isVideo!)
                {
                    let movieData: Data?
                    do {
                        movieData = try Data(contentsOf: postContent.videoURL!, options: Data.ReadingOptions.alwaysMapped)
                    } catch _ {
                        movieData = nil
                        TillUtil.showAlertFromController(controller: nil, withMessage: "Something wrong with video file. Please select another.")
                        TillGlobalObject.hideProgressHUD()
                        return
                    }
                    
                    let thumbData:Data = (postContent.imageContent?.jpegData(compressionQuality: 0.7))!
                    multipartFormData.append(postContent.videoURL!, withName: mediaFile)
                    //                    multipartFormData.append(movieData!, withName: mediaFile, mimeType: "video/*")
                    multipartFormData.append(thumbData, withName:thumbNailKey, fileName: "postthumb\(index).jpg", mimeType: "image/jpg")
                }
                else{
                    let imgData:Data = (postContent.imageContent?.jpegData(compressionQuality: 0.9))!
                    let thumbData:Data = (postContent.imageContent?.jpegData(compressionQuality: 0.4))!
                    multipartFormData.append(imgData, withName:mediaFile, fileName: "postcontent\(index).jpg", mimeType: "image/jpg")
                    multipartFormData.append(thumbData, withName:thumbNailKey, fileName: "postthumb\(index).jpg", mimeType: "image/jpg")
                }
                //            post_media[2][thumbnail]
                //            post_media[2][media_file]
            }
            
        }, to: BaseAPIPath + "post/create" ,method: .post, headers: header) { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON {response in
                    
                    if let _ = response.result.value {
                        let jsonResult: JSON = JSON(response.result.value!)
                        
                        //                        let user = TillUser(parameter: jsonResult["data"])
                        
                        let response = TillAPIResponse(parameter: jsonResult)
                        
                        if(!self.checkForAuthorization(code: (response.meta?.status_code)!)){
                            self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                            completion(nil)
                        }
                        else{
                            completion(response)
                        }
                    }
                    else{
                        TillUtil.showAlertFromController(controller: nil, withMessage: (response.result.error?.localizedDescription)!)
                        completion(nil)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(nil)
            }
        }
    }
    
    func SubscribeToPlan(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.SubscribeToPlan(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: jsonResult["status_code"].intValue)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else
                    {
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func GetListFollowerFollowing(_ parameter:[String: Any]?, completion:@escaping ([TillUser]?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.GetFollowFollowingUser(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value
                {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion([],parsedResponse, 0)
                    }
                    else
                    {
                        
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        print(totalRecords)
                        
                        let users = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillUser.self) ?? [] ) as! [TillUser]
                        completion(users,parsedResponse, totalRecords)
                        
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse, 0)
            }
        }
    }
    
    func GetFeedPost(_ parameter:[String: Any]?, completion:@escaping ([TillPost]?,TillAPIResponse?,Int) -> Void)
    {
        print("Feed Parameters: \(String(describing: parameter))")
        self.sendRequest(.GetPostListing(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    print("Feed Response: \(jsonResult)")
                    
                    let successCode =  parsedResponse.meta?.status_code
                    
                    if successCode == 200{
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        let posts = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillPost.self) ?? [] ) as! [TillPost]
                        
                        completion(posts,parsedResponse,totalRecords)
                    }else{
                        parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                        completion([],parsedResponse,0)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion([],parsedResponse,0)
            }
        }
    }
    
    
    func LikeUnlikePost(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.LikeUnlikePost(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func checkUsername(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.CheckUsername(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    //MARK:- Follow UnFollow API
    func FollowUnfollowApi(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.FollowUnfollow(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    //MARK:- Fetch ContactList base our mobile contact
    func fetchConatctList(_ parameter:[String: Any]?, completion:@escaping ([TillConatct]?,TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.ConatactList(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    if parsedResponse.meta?.status_code == TillAPI.RCode.Success{
                        let conatct =  (jsonResult[TillAPI.RKey.Data])["contacts"].to(type: TillConatct.self) as! [TillConatct]
                        completion(conatct,parsedResponse)
                    }else{
                         completion([],parsedResponse)
                    }
                    
                    
                    
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion([],parsedResponse)
            }
        }
    }
    
    //MARK:- Comment List API
    func GetCommentList(_ parameter:[String: Any]?, completion:@escaping ([TillComment]?,TillAPIResponse?,Int) -> Void)
    {
        print("Feed Parameters: \(String(describing: parameter))")
        self.sendRequest(.GetCommentListing(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    print("Feed Response: \(jsonResult)")
                    
                    let successCode =  parsedResponse.meta?.status_code
                    
                    if successCode == 200{
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        let comments = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillComment.self) ?? [] ) as! [TillComment]
                        
                        completion(comments,parsedResponse,totalRecords)
                    }else{
                        parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                        completion([],parsedResponse,0)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion([],parsedResponse,0)
            }
        }
    }
    
    //MARK:- Comment Create API
    func CommentCreateApi(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.CommentCreate(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    func ChangePassword(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.ChangePSWD(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func PushNotificationAllow(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.PushNoti(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                    
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func searchPeople(_ parameter:[String: Any]?, completion:@escaping ([Tillpeople]?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.searchPeople(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    let valPeople = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: Tillpeople.self) ?? []) as! [Tillpeople]
                    let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                    
                    completion(valPeople,parsedResponse,totalRecords)
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion([],parsedResponse,0)
            }
        }
    }
    
    
    func searchHastag(_ parameter:[String: Any]?, completion:@escaping ([TillHastag]?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.searchPeople(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    let valHastag = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillHastag.self) ?? []) as! [TillHastag]
                    let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                    
                    completion(valHastag,parsedResponse,totalRecords)
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion([],parsedResponse,0)
            }
        }
    }
    
    func searchPeopleAndHastag(_ parameter:[String: Any]?, completion:@escaping (TillHastagandUser?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.searchPeople(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    let tillHastagUser = (jsonResult[TillAPI.RKey.Data]).to(type: TillHastagandUser.self) as! TillHastagandUser
                    print(jsonResult)
                    completion(tillHastagUser,parsedResponse,1)
                    
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                
                completion(nil,parsedResponse,0)
            }
        }
    }
    //MARK:- Post Edit API
    func  PostEditApi(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.PostEdit(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    //MARK:- Post Delete API
    func PostDeleteApi(_ postId:String?,completion:@escaping (TillAPIResponse?) -> Void)
    {
        self.sendRequest(.PostDelete(), withEndPath: postId!).responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    //MARK:- Post Report API
    func PostReportApi(_ parameter:[String: Any]?,completion:@escaping (TillAPIResponse?) -> Void)
    {
        self.sendRequest(.PostReport(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    //MARK:- Most Follow API
    func GetMostFollowApi(_ parameter:[String: Any]?, completion:@escaping ([TillPost]?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.MostFollow(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value
                {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    print("Most Follow Response: \(jsonResult)")
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion([],parsedResponse, 0)
                    }
                    else
                    {
                        
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        let mostFollow = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillPost.self) ?? [] ) as! [TillPost]
                        completion(mostFollow,parsedResponse, totalRecords)
                        
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse, 0)
            }
        }
    }
    
    //MARK:- Hash tag API
    func GetHashTagApi(_ parameter:[String: Any]?, completion:@escaping ([TillPost]?,TillAPIResponse?, TillHastag?,Int) -> Void)
    {
        
        self.sendRequest(.HashTags(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value
                {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    print("Most Follow Response: \(jsonResult)")
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion([],parsedResponse, nil,0)
                    }
                    else
                    {
                        
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        let hashTags = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillPost.self) ?? [] ) as! [TillPost]
                        let hashTagDetail = TillHastag(parameter: jsonResult[TillAPI.RKey.Data]["hashtag"])
                        completion(hashTags,parsedResponse, hashTagDetail,totalRecords)
                        
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse,nil, 0)
            }
        }
    }
    
    //MARK:- Hash tag List API
    func getListOfHastag(_ parameter:[String: Any]?, completion:@escaping ([TillHastag]?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.HasTagList(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(nil,parsedResponse,0)
                    }
                    else{
                        let valHastag = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillHastag.self) ?? []) as! [TillHastag]
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        completion(valHastag,parsedResponse,totalRecords)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse, 0)
            }
        }
    }
    
    //MARK:- Post List API
    func GetPostList(_ parameter:[String: Any]?, completion:@escaping ([TillPost]?,TillAPIResponse?,Int) -> Void)
    {
        print("Post List Parameters: \(String(describing: parameter))")
        self.sendRequest(.postsList(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    print("Post List Response: \(jsonResult)")
                    
                    let successCode =  parsedResponse.meta?.status_code
                    
                    if successCode == 200{
                        let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        let posts = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillPost.self) ?? [] ) as! [TillPost]
                        
                        completion(posts,parsedResponse,totalRecords)
                    }else{
                        parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                        completion([],parsedResponse,0)
                    }
                    
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion([],parsedResponse,0)
            }
        }
    }
    //ShowPostApi
    func showPost(_ parameter:[String: Any]?, completion:@escaping (TillPost?,TillAPIResponse?) -> Void)
    {
      
        self.sendRequest(.ShowPost(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    print("Post List Response: \(jsonResult)")
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(nil,parsedResponse)
                    }
                    else{
                        if (parsedResponse.meta?.status_code == TillAPI.RCode.Success){
                        let posts = (jsonResult[TillAPI.RKey.Data].to(type: TillPost.self) ?? () ) as! TillPost
                        
                        completion(posts,parsedResponse)
                        }
                        else{
                            completion(nil,parsedResponse)
                        }
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let dataString = String.init(data: response.data! , encoding: .utf8)
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse)
            }
        }
    }
    
    
    func GetTrendings(_ parameter:[String: Any]?, completion:@escaping ([TillPost]?,TillAPIResponse?,Int) -> Void)
    {
        
        self.sendRequest(.GetTrendings(parameter!), withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    //                    if(!self.checkForAuthorization(code: jsonResult["code"].intValue)){
                    //                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                    //                        completion(nil,parsedResponse,0)
                    //                    }
                    let media = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillPost.self) ?? []) as! [TillPost]
                    let totalRecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                    
                    completion(media,parsedResponse,totalRecords)
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse, 0)
            }
        }
    }
    
    func  GetTokenListApi(completion:@escaping(TillTokens?,TillAPIResponse?) -> Void) {
        
        sendRequest(.GetTokenList(), withEndPath: "").responseJSON { response in
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        
                        completion(nil,parsedResponse)
                    }
                    else{
                        let tokendata = TillTokens(parameter: jsonResult[TillAPI.RKey.Data])
                        //                    let tokendata = (jsonResult[TillAPI.RKey.Data])
                        
                        
                        completion(tokendata,parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse)
            }
        }
    }
    func  GetGiftCardList(completion:@escaping([TillGiftCard]?,TillAPIResponse?) -> Void) {
        
        sendRequest(.GetGiftCardList(), withEndPath: "").responseJSON { response in
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    //                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        
                        completion(nil,parsedResponse)
                    }
                    else{
                        
                        let giftcardData = (jsonResult[TillAPI.RKey.Data]["gift_cards"].to(type: TillGiftCard.self) ?? []) as! [TillGiftCard]
                        completion(giftcardData,parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse)
            }
        }
    }
    
    func GiftTransHistory(_ parameter : [String:Any]?, completion:@escaping([TillGiftcardTransaction]?,TillAPIResponse?,Int) -> Void) {
        
        sendRequest(.GetGiftTransactionList(parameter!), withEndPath: "").responseJSON { response in
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        
                        completion(nil,parsedResponse,0)
                    }
                    else{
                        let transactionList = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillGiftcardTransaction.self) ?? []) as! [TillGiftcardTransaction]
                        let Totalrecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        completion(transactionList,parsedResponse,Totalrecords)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse,0)
            }
        }
    }
    
    func GetNotificationList(_ parameter : [String:Any]?, completion:@escaping([TillNotification]?,TillAPIResponse?,Int) -> Void) {
        
        sendRequest(.GetNotificationList(parameter!), withEndPath: "").responseJSON { response in
            switch response.result {
            case .success:
                if let _ = response.result.value {
                    let jsonResult: JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        
                        completion(nil,parsedResponse,0)
                    }
                    else{
                        let notificationList = (jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original][TillAPI.RKey.Data].to(type: TillNotification.self) ?? []) as! [TillNotification]
                        let Totalrecords = jsonResult[TillAPI.RKey.Data][TillAPI.RKey.Original]["recordsTotal"].intValue
                        
                        completion(notificationList,parsedResponse,Totalrecords)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(nil,parsedResponse,0)
            }
        }
    }
    
    func NotificationDidReadApi(completion:@escaping(TillAPIResponse?) -> Void) {
        sendRequest(.NotificatioRead(), withEndPath: "").responseJSON { response in
            switch response.result {
            case .success :
                if let _ = response.result.value {
                    let jsonResult:JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    completion(parsedResponse)
                }
            case .failure(let error) :
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    func RedeeemYourTokens(_ parameter: [String:Any]?,completion: @escaping(TillAPIResponse?)-> Void) {
        sendRequest(.RedeemTokens(parameter!), withEndPath: "").responseJSON {
            response in
            switch response.result {
            case .success :
                if let _ = response.result.value{
                    let jsonResult:JSON = JSON(response.result.value!)
                    print(jsonResult)
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!)){
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                var message = ""
                if(error.localizedDescription.length != 0)
                {
                    message = error.localizedDescription
                }
                else{
                    message = TillText.AppMessages.SomethingWentWrong
                }
                parsedResponse.meta?.message = message
                completion(parsedResponse)
            }
            
        }
    }
    
    func Logout(_ parameter:[String: Any]?, completion:@escaping (TillAPIResponse?) -> Void)
    {
        
        self.sendRequest(.Logout, withEndPath: "").responseJSON { response in
            
            switch response.result {
            case .success:
                
                if let _ = response.result.value {
                    
                    let jsonResult: JSON = JSON(response.result.value!)
                    
                    let parsedResponse = TillAPIResponse(parameter: jsonResult)
                    
                    if(!self.checkForAuthorization(code: (parsedResponse.meta?.status_code)!))
                    {
                        self.handleUnauthorization(msg: jsonResult["message"].stringValue)
                        completion(parsedResponse)
                    }
                    else{
                        completion(parsedResponse)
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
                let parsedResponse = TillAPIResponse.init()
                parsedResponse.meta?.status_code = 10000
                parsedResponse.meta?.message = TillText.AppMessages.SomethingWentWrong
                completion(parsedResponse)
            }
        }
    }
    
    //    func GetTrandings(_parameter :[String :Any]?,completion:@escaping([TillTrendings]?,TillAPIResponse?,Int)) -> Void {
    //
    //      self.sendRequest(.GetTrendings(_parameter), withEndPath: "").response
    //    }
    
    
}
