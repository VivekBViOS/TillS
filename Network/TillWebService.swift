//
//  HTWebService.swift
//  
//
//  Created by VB on 02/01/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let TillWebServiceAPI: TillWebService = TillWebService.APIClient

class TillWebService: SessionManager {

    var header = [
        "Content-type":"application/json",
        TillAPI.accessToken: ""
    ]
    
    static let APIClient: TillWebService = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 180
        configuration.timeoutIntervalForRequest  = 180
        
        return TillWebService(configuration: configuration)
    }()
    
    func set(authorizeToken token: String?) {
        
        header[TillAPI.accessToken] = "Bearer "+token!
    }
    
    func removeAuthorizeToken() {
        
        header.removeValue(forKey: TillAPI.accessToken)
    }
    
    func sendRequest(_ route: Router, withEndPath endPath: String)
        -> DataRequest {
            
            var path = route.path + endPath
            path = path.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
            print(path)
            var encoding: ParameterEncoding = JSONEncoding.default
            if route.method == .get {
                encoding = URLEncoding.default
            }
            
            return self.request(path, method: route.method, parameters: route.parameters, encoding: encoding, headers: header)
    }
    
    func checkForAuthorization(code:Int) -> Bool{
        if(code == 401){
            return false
        }else{
            return true
        }
    }
    
    func handleUnauthorization(msg:String)
    {
        
        TillUtil.showAlertFromController(controller: nil, withMessage:TillText.AppMessages.SessionExpired) { action in
            TillGlobalObject.user?.logOut()
            TillUtil.RedierctToLogin()
        }
        
    }
    
}

class TillAPIResponse: NSObject, NSCoding, JSONable {
    
    
    
    //MARK: - Properties
    let meta          : TillMeta?

    //MARK: - Methods
    required init(parameter: JSON) {

        meta = TillMeta(parameter: parameter[TillAPI.RKey.Meta])

    }

    //MARK: - Methods
    required override init() {

        meta = TillMeta.init()

    }

    required init(coder aDecoder: NSCoder) {

        meta = aDecoder.decodeObject(forKey: TillAPI.RKey.Meta) as? TillMeta
    }

    func encode(with aCoder: NSCoder) {

        aCoder.encode(meta, forKey: TillAPI.RKey.Meta)

    }
}

