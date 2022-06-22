//
//  DegpegManager.swift
//  Degpeg
//
//  Created by Raj Kadam on 25/04/22.
//

import Foundation
import UIKit
import ObjectMapper
public class DegpegManager {
    
    private var authKey: String
    
    public init(appID: String, secret: String, userId: String, userName: String, influencerID: String) {
        authKey = appID
        B2CUserDefaults.setAppID(id: appID)
        B2CUserDefaults.setAppSercet(secret: secret)
        B2CUserDefaults.setUserId(id: userId)
        B2CUserDefaults.setInfluencerID(id: influencerID)
        B2CUserDefaults.setUserName(name: userName)
    }
    
    public func getRootViewController() -> UINavigationController? {
        // MARK:- TODO
        // Call API to check Auth key is valid
        // if not return  nil
        let param = ["appId": B2CUserDefaults.getAppID(), "secretKey": B2CUserDefaults.getAppSercet()]
        
        self.getJWTToken(param: param)
        let bundle = Bundle(for: type(of: self))
        let b = Bundle.init(for: DegpegManager.self)
        let path = b.path(forResource: "B2CSDK", ofType: "bundle")
        let r_bundle = Bundle(url: URL.init(fileURLWithPath: path!))
        
        let storyboard = UIStoryboard.init(name: Storyboards.DEGPEG_STORYBOARD, bundle: r_bundle)
        if #available(iOS 13.0, *) {
            let nav = storyboard.instantiateViewController(identifier: StoryboardID.ROOT_NAVIGATION) as! UINavigationController
            return nav
        } else {
            // Fallback on earlier versions
            let nav = storyboard.instantiateViewController(withIdentifier: StoryboardID.ROOT_NAVIGATION) as! UINavigationController
            
            return nav
        }
        
        
        
    }
    
    private func checkUser() {
        
    }
    func getJWTToken(param: [String: Any]) {
        let endPoint = "\(APIConstants.JWT_TOKEN)"
        let header = APIClient.getInstance().getJWTHeader()
        APIClient.getInstance().requestJson(endPoint, .post, parameters: param) { result, error, refresh, code in
            if code == ResponseCode.success {
                print("code: ", code)
            }
            if (200 ... 299).contains(code) {
                if let result = result {
                    let tokenModel = Mapper<JWTModel>().map(JSONObject: result)
                    B2CUserDefaults.setAccessToken(token: tokenModel?.token)
                    //completionHandler(tokenModel, nil)
                } else {
                    //completionHandler(nil, error)
                }//
            }else {
                //completionHandler(nil, error)
            }
        }
    }
    
}

private struct Approved {
    static let keys = ["1234", "abcd"]
}
