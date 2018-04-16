//
//  Services.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

struct ServiceName {
    
    static let changePassword = "/changePassword/"
    static let contactUs = "/contactUs/"
    static let editUser = "/editUser/"
    static let facebookLogin = "/facebookLogin/"
    static let forgotPassword = "/forgotPassword/"
    static let getAboutUs = "/getAboutUs/"
    static let getCountries = "/getCountries/"
    static let getLeaderboards = "/getLeaderboards/"
    static let getMatches = "/getMatches/"
    static let getNews = "/getNews/"
    static let getNotifications = "/getNotifications/"
    static let getPackages = "/getPackages/"
    static let getPredictions = "/getPredictions/"
    static let getTeams = "/getTeams/"
    static let googleLogin = "/googleLogin/"
    static let login = "/login/"
    static let logout = "/logout/"
    static let registerUser = "/registerUser/"
    static let updateAvatar = "/updateAvatar/"
}

enum ResponseStatus: Int {
    
    case SUCCESS = 1
    case FAILURE = 0
    case CONNECTION_TIMEOUT = -1
    case UNAUTHORIZED = -2
    
}

enum ResponseMessage: String {
    
    case SERVER_UNREACHABLE = "An error has occured, please try again."
    case CONNECTION_TIMEOUT = "Check your internet connection."
    
}

class ResponseData {
    
    var status: Int = ResponseStatus.SUCCESS.rawValue
    var message: String = String()
    var json: [NSDictionary]? = [NSDictionary]()
    var jsonObject: JSON? = JSON((Any).self)
    
}

class Services {
    
    private static var _UserId: String = ""
    var USER_ID: String {
        get {
            if let token = UserDefaults.standard.string(forKey: Keys.UserId.rawValue) {
                Services._UserId = token
            }
            
            return Services._UserId.isEmpty ? "1" : Services._UserId
        }
    }
    
    static let ConfigUrl = "http://config.foot-win.com/"
    //    private let ConfigUrl = "http://localhost/footwin/services/getConfig/"
    
    private static var _BaseUrl: String = ""
    var BaseUrl: String {
        get {
            return Services._BaseUrl
        }
        set {
            Services._BaseUrl = newValue
        }
    }
    
    private static var _MediaUrl: String = ""
    var MediaUrl: String {
        get {
            return Services._MediaUrl
        }
        set {
            Services._MediaUrl = newValue
        }
    }
    
    func getConfig() -> ResponseData? {
        return makeHttpRequest(method: .post, isConfig: true)
    }
    
    func changePassword(id: String, oldPassword: String, newPassword: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        let serviceName = ServiceName.changePassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func contactUs(name: String, email: String, phone: String, message: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "fullname": name,
            "email": email,
            "phone": phone,
            "message": message
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.contactUs
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func editUser(id: String, fullname: String, email: String, country: String, phone: String, gender: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id,
            "fullname": fullname,
            "email": email,
            "country": country,
            "phone": phone,
            "gender": gender
        ]
        
        let serviceName = ServiceName.editUser
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func facebookLogin(user: User) -> ResponseData? {
        
        let parameters: Parameters = [
            "facebook_id": user.facebook_id ?? "",
            "facebook_token": user.facebook_token ?? "",
            "fullname": user.fullname ?? "",
            "email": user.email ?? "",
            "gender": user.gender ?? "",
        ]
        
        let serviceName = ServiceName.facebookLogin
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func forgotPassword(email: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "email": email
        ]
        
        let serviceName = ServiceName.forgotPassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func getAboutUs() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getAboutUs
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getCountries() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getCountries
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getLeaderboards() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getLeaderboards
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getMatches() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getMatches
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getNews() -> ResponseData? {
     
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getNews
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getNotifications() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getNotifications
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getPackages() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getPackages
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getPredictions() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getPredictions
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func getTeams() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getTeams
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers)
    }
    
    func googleLogin(user: User) -> ResponseData? {
        
        let parameters: Parameters = [
            "google_id": user.google_id ?? "",
            "google_token": user.google_token ?? "",
            "fullname": user.fullname ?? "",
            "email": user.email ?? "",
            "gender": user.gender ?? "",
            ]
        
        let serviceName = ServiceName.googleLogin
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func login(email: String, password: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        let serviceName = ServiceName.login
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func logout(id: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "id": id
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.logout
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func registerUser(user: User) -> ResponseData? {
        
        var parameters = [
            "fullname": user.fullname ?? "",
            "username": user.username ?? "",
            "email": user.email ?? "",
            "password": user.password ?? ""
        ]
        
        parameters["phone_code"] = user.phone_code
        parameters["phone"] = user.phone
        parameters["country"] = user.country
        parameters["gender"] = user.gender
        parameters["favorite_team"] = user.favorite_team
        
        let serviceName = ServiceName.registerUser
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters)
    }
    
    func updateAvatar(userId: String, image : UIImage, completion:@escaping(_:ResponseData)->Void) {
        self.uploadImageData(userId: userId, serviceName: ServiceName.updateAvatar, imageFile: image, completion: completion)
    }
    
    func uploadImageData(userId: String, serviceName: String, imageFile : UIImage, completion:@escaping(_:ResponseData)->Void) {
        
        let headers: HTTPHeaders = [
            "User-Id": userId
        ]
        
        let imageData = imageFile.jpeg(.medium)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: BaseUrl + serviceName, headers: headers)
        { (result) in
            let responseData = ResponseData()
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                })
                
                upload.responseJSON { response in
                    if let json = response.result.value as? NSDictionary {
                        responseData.status = ResponseStatus.SUCCESS.rawValue
                        responseData.json = [json]
                        
                        completion(responseData)
                    } else {
                        responseData.status = ResponseStatus.FAILURE.rawValue
                        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
                        responseData.json = nil
                        completion(responseData)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                responseData.status = ResponseStatus.FAILURE.rawValue
                responseData.json = nil
                completion(responseData)
            }
        }
    }
    
    /************* SERVER REQUEST *************/
    
    private func makeHttpRequest(method: HTTPMethod, serviceName: String = "", parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, isConfig: Bool = false) -> ResponseData {
        
        var requestUrl = BaseUrl
        if isConfig {
            requestUrl = Services.ConfigUrl
        }
        
        let response = manager.request(requestUrl + serviceName, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(options: .allowFragments)
        let responseData = ResponseData()
        responseData.status = ResponseStatus.FAILURE.rawValue
        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
        
        if let jsonArray = response.result.value as? [NSDictionary] {
            let json = jsonArray.first
            if let status = json!["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json!["message"] as? String {
                responseData.message = message
            }
            if let message = json!["message"] as? Bool {
                responseData.message = String(message)
            }
            
            if let json = jsonArray.last {
                responseData.json = [json]
            }
            
        } else if let json = response.result.value as? NSDictionary {
            if let status = json["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json["message"] as? String {
                responseData.message = message
            }
            if let message = json["message"] as? Bool {
                responseData.message = String(message)
            }
            
            responseData.json = [json]
            
        } else if let jsonArray = response.result.value as? NSArray {
            if let jsonStatus = jsonArray.firstObject as? NSDictionary {
                if let status = jsonStatus["status"] as? Int {
                    responseData.status = status
                }
            }
            
            if let jsonData = jsonArray.lastObject as? NSArray {
                responseData.json = [NSDictionary]()
                for jsonObject in jsonData {
                    if let json = jsonObject as? NSDictionary {
                        responseData.json?.append(json)
                    }
                }
            }
        } else {
            responseData.status = ResponseStatus.FAILURE.rawValue
            responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
            responseData.json = nil
        }
        
        if responseData.status == ResponseStatus.UNAUTHORIZED.rawValue {
            if let baseVC = currentVC as? BaseViewController {
                baseVC.logout()
            }
        }
        
        return responseData
        
    }
    
    let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 5
        return SessionManager(configuration: configuration)
        
    }()
    
    static func getBaseUrl() -> String {
        return _BaseUrl
    }
    
    static func setBaseUrl(url: String) {
        _BaseUrl = url
    }
    
    static func getMediaUrl() -> String {
        return _MediaUrl
    }
    
    static func setMediaUrl(url: String) {
        _MediaUrl = url
    }
}

