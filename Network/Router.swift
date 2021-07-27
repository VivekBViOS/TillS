//
//  Router.swift
//
//
//  Created by VB on 12/01/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import Alamofire

let AboutTillPathURl = ""

let WebUrlforToken = ""


let BasePath = ""

let BaseProfileImagePath = BasePath + ""

let BaseAPIPath = BasePath + "api/v1/"

protocol Routable {
    var path        : String {get}
    var method      : HTTPMethod {get}
    var parameters  : Parameters? {get}
}

enum Router: Routable {
    
    case logIn(Parameters)
    case signUp(Parameters)
    case getSubscriptionPlan
    case ForgotPSWD(Parameters)
    case ChangePSWD(Parameters)
    case resendVerificationMail()
    case CreatePost(Parameters)
    case SubscribeToPlan(Parameters)
    case GetFollowFollowingUser(Parameters)
    case GetPostListing(Parameters)
    case LikeUnlikePost(Parameters)
    case FollowUnfollow(Parameters)
    case ConatactList(Parameters)
    case GetCommentListing(Parameters)
    case CommentCreate(Parameters)
    case PushNoti(Parameters)
    case searchPeople(Parameters)
    case PostEdit(Parameters)
    case PostDelete()
    case MostFollow(Parameters)
    case GetProfile(Parameters)
    case PostReport(Parameters)
    case HashTags(Parameters)
    case HasTagList(Parameters)
    case UpdateProfile(Parameters)
    case postsList(Parameters)
    case GetTrendings(Parameters)
    case GetTokenList()
    case GetGiftCardList()
    case GetGiftTransactionList(Parameters)
    case RedeemTokens(Parameters)
    case GetNotificationList(Parameters)
    case SendMailTorecipent(Parameters)
    case ShowPost(Parameters)
    case NotificatioRead()
    case CheckUsername(Parameters)
    case Logout

}

extension Router {
    
    var path: String {
        
        switch self {
            
        case .logIn:
            return BaseAPIPath + "oauth/signin"
        case .signUp:
            return BaseAPIPath + "oauth/signup"
        case .getSubscriptionPlan:
            return BaseAPIPath + "membership-plan/list"
        case .ForgotPSWD :
            return BaseAPIPath + "oauth/password/forgot"
        case .ChangePSWD :
            return BaseAPIPath + "user/password/change"
        case .resendVerificationMail:
            return BaseAPIPath + "user/reSendMail"
        case .CreatePost:
            return BaseAPIPath + "post/create"
        case .SubscribeToPlan:
            return BaseAPIPath + "oauth/subscribe"
        case .GetFollowFollowingUser:
            return BaseAPIPath + "follow/followerOrfollowing"
        case .GetPostListing:
            return BaseAPIPath + "post/listing"
        case .LikeUnlikePost :
            return BaseAPIPath + "post/like-unlike"
        case .FollowUnfollow:
            return BaseAPIPath + "follow/followUnfollow"
        case .ConatactList:
            return BaseAPIPath + "contacts/details"
        case .GetCommentListing:
            return BaseAPIPath + "post/list-comment"
        case .CommentCreate:
            return BaseAPIPath + "post/comment/create"
        case .PushNoti :
            return BaseAPIPath + "user/update"
        case .searchPeople :
            return BaseAPIPath + "search/all"
        case .PostEdit :
            return BaseAPIPath + "post/edit"
        case .PostDelete :
            return BaseAPIPath + "post/delete/"
        case .MostFollow :
            return BaseAPIPath + "user/mostfollow"
        case .GetProfile :
            return BaseAPIPath + "user/get-profile"
        case .PostReport :
            return BaseAPIPath + "reportabuse/add-report"
        case .HashTags :
            return BaseAPIPath + "hashtag/show"
        case .HasTagList :
            return BaseAPIPath + "hashtag/list"
        case .UpdateProfile :
            return BaseAPIPath + "user/setProfile"
        case .postsList :
            return BaseAPIPath + "post/userpostlist"
        case .GetTrendings :
            return BaseAPIPath + "post/trending"
        case .GetTokenList:
            return BaseAPIPath + "user/tokenlist"
        case .GetGiftCardList :
            return BaseAPIPath + "gift-cards/list"
        case .GetGiftTransactionList :
            return BaseAPIPath + "gift-cards/redeemHistory"
        case .RedeemTokens :
            return BaseAPIPath + "gift-cards/redeem"
        case .GetNotificationList:
            return BaseAPIPath + "notification/list"
        case .SendMailTorecipent :
            return BaseAPIPath + "post/send-post"
        case .ShowPost:
            return BaseAPIPath + "post/showpost"
        case .NotificatioRead :
            return BaseAPIPath + "notification/mark-read-all"
        case .CheckUsername :
            return BaseAPIPath + "check/emailorusername"
        case .Logout :
            return BaseAPIPath + "user/logout"
        
        }
    }
}

extension Router {
    
    var method: HTTPMethod {
        
        switch self {
            
        case .logIn:
            return .post
        case .signUp:
            return .post
        case .ForgotPSWD :
            return .post
        case .ChangePSWD :
            return .post
        case .getSubscriptionPlan :
            return .get
        case .resendVerificationMail:
            return .post
        case .CreatePost:
            return .post
        case .SubscribeToPlan:
            return .post
        case .GetFollowFollowingUser:
            return .post
        case .GetPostListing:
            return .post
        case .LikeUnlikePost :
            return .post
        case .FollowUnfollow:
            return .post
        case .ConatactList:
            return .post
        case .GetCommentListing:
            return .post
        case .CommentCreate:
            return .post
        case .PushNoti:
            return .post
        case .searchPeople:
            return .post
        case .PostEdit:
            return .post
        case .PostDelete:
            return .delete
        case .MostFollow:
            return .post
        case .GetProfile :
            return .post
        case .PostReport:
            return .post
        case .HashTags:
            return .post
        case .HasTagList :
            return .post
        case .UpdateProfile :
            return .post
        case .postsList :
            return .post
        case .GetTrendings :
            return .post
        case .GetTokenList :
            return .post
        case .GetGiftCardList :
            return .get
        case .GetGiftTransactionList :
            return .get
        case .RedeemTokens :
            return .post
        case .GetNotificationList:
            return .post
        case .SendMailTorecipent :
            return .post
        case .ShowPost  :
            return .post
        case .NotificatioRead :
            return .post
        case .CheckUsername :
            return .post
        case .Logout:
            return .post

        }
    }
}


extension Router{
    
    var parameters: Parameters? {
        
        switch self {

        case .logIn(let param):
            return param
        case .signUp(let param):
            return param
        case .getSubscriptionPlan:
            return nil
        case .ForgotPSWD(let param) :
            return param
        case .ChangePSWD(let param) :
            return param
        case .resendVerificationMail():
            return nil
        case .CreatePost(let param):
            return param
        case .SubscribeToPlan(let param):
            return param
        case .GetFollowFollowingUser(let param):
            return param
        case .GetPostListing(let param):
            return param
        case .LikeUnlikePost(let param):
            return param
        case .FollowUnfollow(let param):
            return param
        case .ConatactList(let param):
            return param
        case .GetCommentListing(let param):
            return param
        case .CommentCreate(let param):
            return param
        case .PushNoti(let param):
            return param
        case .searchPeople(let param):
            return param
        case .PostEdit(let param):
            return param
        case .PostDelete():
            return nil
        case .MostFollow(let param):
            return param
        case .GetProfile(let param):
            return param
        case .PostReport(let param):
            return param
        case .HashTags(let param):
            return param
        case .HasTagList(let param) :
            return param
        case .UpdateProfile(let param) :
            return param
        case .postsList(let param) :
            return param
        case .GetTrendings(let param) :
            return param
        case .GetTokenList() :
            return nil
        case .GetGiftCardList() :
            return nil
        case .GetGiftTransactionList(let param) :
            return param
        case .RedeemTokens(let param) :
            return  param
        case .GetNotificationList(let param):
            return param
        case .SendMailTorecipent(let param) :
            return  param
        case .ShowPost(let param):
            return param
        case .NotificatioRead() :
            return nil
        case .CheckUsername(let param):
            return param
        case .Logout:
            return nil
        }
    }
}
