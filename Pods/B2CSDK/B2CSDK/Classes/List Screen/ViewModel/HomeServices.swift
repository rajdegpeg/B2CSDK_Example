//
//  HomeServices.swift
//  B2CSDK
//
//  Created by Raj Kadam on 18/05/22.
//

import Foundation
import ObjectMapper
import Alamofire
import AVFAudio
struct HomeService {
    
    
    func getJWTToken(param: [String: Any], completionHandler: @escaping (ServiceError?) -> Void){
        let endPoint = "\(APIConstants.JWT_TOKEN)"
        APIClient.getInstance().requestJson(endPoint, .post, parameters: param) { result, error, refresh, code in
            if code == ResponseCode.success {
                print("code: ", code)
            }
            if (200 ... 299).contains(code) {
                if let result = result {
                    let tokenModel = Mapper<JWTModel>().map(JSONObject: result)
                    B2CUserDefaults.setAccessToken(token: tokenModel?.token)
                    completionHandler(nil)
                } else {
                    completionHandler(error)
                }//
            }else {
                completionHandler(error)
            }
        }
    }
    
    func getContentPublisherDetails(contentPublisherId: String, completionHandler: @escaping (ContentPublishersDetails?, ServiceError?) -> Void) {
        let header = APIClient.getInstance().getJWTHeader()
        let endPoint = "\(APIConstants.ContentPublisher)/\(contentPublisherId)"
        APIClient.getInstance().requestJson( endPoint, .get, parameters: nil, headers: header) { (result, error, isExpire, code) in
            if isExpire {
                //UIUtils.showDefaultAlertView(title: AlertTitles.Error, message: "Token exp")
                completionHandler(nil, ServiceError.init(statusCode: 0, message: ""))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let details = Mapper<ContentPublishersDetails>().map(JSONObject: result)
                    completionHandler(details, nil)
                }
            }
        }
    }
    
    
    func getContentProviderVideos(contentProviderId: String, completionHandler: @escaping ([ContentProviderDetailsModel]?, ServiceError?) -> Void) {
      
//        let fil = "https://dev.api.degpeg.com/content-providers/${id}/live-sessions?filter={"include":[{"relation":"liveSessionCategory"}],"where":{"status":{"neq":"deleted"}}}"
        let header = APIClient.getInstance().getJWTHeader()
        let endPoint = "\(APIConstants.ContentProviders)/\(contentProviderId)/live-sessions"

        let neqDict = ["neq":"deleted"]
        let whereParam = ["status":neqDict]
        let includeObject = ["relation":"liveSessionCategory"]
        let includeAr = [includeObject]
        let filterParam = ["include":includeAr, "where":whereParam] as [String : Any]
        let param = ["filter":filterParam]
        APIClient.getInstance().requestJson( endPoint, .get, parameters: param,  encoding:  URLEncoding.default, headers: header) { (result, error, isExpire, code) in
            if isExpire {
                
                completionHandler(nil, ServiceError.init(statusCode: 0, message: ""))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result as? NSArray{
                    let videoList = Mapper<ContentProviderDetailsModel>().mapArray(JSONArray: result as! [[String : Any]])
                    
                    completionHandler(videoList, nil)
                }
            }
        }
    }
    
    // MARK: - Get Channel Details
    func getChannelDetails(for channelID: String, completionHandler: @escaping (ChannelData?, ServiceError?) -> Void) {
        let endPoint = "\(APIConstants.Channels)/\(channelID)"
        let header = APIClient.getInstance().getJWTHeader()
        APIClient.getInstance().requestJson(endPoint, .get, headers: header) { result, error, refresh, code in
            if let result = result {
                let session = Mapper<ChannelData>().map(JSONObject: result as! [String: Any])
                completionHandler(session, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    // MARK: - Get Categories
    func getAllCategories(completionHandler: @escaping ([CategoryData]?, ServiceError?) -> Void) {
        let endPoint = "\(APIConstants.CategoriesList)"
        let header = APIClient.getInstance().getJWTHeader()
        APIClient.getInstance().requestJson( endPoint, .get, parameters: nil, encoding: URLEncoding.default, headers: header) { (result, error, isExpire, code) in
            if isExpire {
                completionHandler(nil, ServiceError.init(statusCode: 0, message: "Token exp"))
            } else {
                 if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let categories = Mapper<CategoryData>().mapArray(JSONArray: result as! [[String : Any]])
                    completionHandler(categories, nil)
                }
            }
        }
    }
}

extension HomeService {
    // MARK: - User Details
    func getUserDetails(param: [String: Any], completionHandler: @escaping ([UserDetails]?, ServiceError?) -> Void) {
        
        let endPoint = "\(APIConstants.UserDetail)"
        let header = APIClient.getInstance().getJWTHeader()
        APIClient.getInstance().requestJson( endPoint, .get, parameters: param, encoding: URLEncoding.default, headers: header) { (result, error, isExpire, code) in
            if isExpire {
                completionHandler(nil, ServiceError.init(statusCode: 0, message: "Token exp"))
            } else {
                if let error = error {
                    completionHandler(nil, error)
                }else if let result = result {
                    let details = Mapper<UserDetails>().mapArray(JSONArray: result as! [[String : Any]])
                    completionHandler(details, nil)
                }
            }
        }
    }
}
