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
    static let getGlobalData = "/getGlobalData/"
    static let getLeaderboard = "/getLeaderboard/"
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
    static let sendNotification = "/sendNotification/"
    static let sendPredictions = "/sendPredictions/"
    static let updateActiveMatches = "/updateActiveMatches/"
    static let updateAvatar = "/updateAvatar/"
    static let updateFirebaseToken = "/updateFirebaseToken/"
    static let updateMatchResult = "/updateMatchResult/"
    static let updateNotification = "/updateNotification/"
    static let getReward = "/getReward/"
    static let purchaseCoins = "/purchaseCoins/"
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
            if let userId = UserDefaults.standard.string(forKey: Keys.UserId.rawValue) {
                Services._UserId = userId
            }
            
            return Services._UserId.isEmpty ? "0" : Services._UserId
        }
    }
    
//    static let ConfigUrl = "http://test.config.foot-win.com/"
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
    
    private static var _NewsUrl: String = ""
    var NewsUrl: String {
        get {
            return Services._NewsUrl
        }
        set {
            Services._NewsUrl = newValue
        }
    }
    
    private static var _AdminUrl: String = ""
    var AdminUrl: String {
        get {
            return Services._AdminUrl
        }
        set {
            Services._AdminUrl = newValue
        }
    }
    
    func getConfig() -> ResponseData? {
        return makeHttpRequest(method: .post, isConfig: true)
    }
    
    func changePassword(id: String, oldPassword: String, newPassword: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.changePassword
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
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
    
    func editUser(id: String, fullname: String, email: String, country: String, phone_code: String, phone: String, gender: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "fullname": fullname,
            "email": email,
            "country": country,
            "phone_code": phone_code,
            "phone": phone,
            "gender": gender
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.editUser
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
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
    
    func getGlobalData() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getGlobalData
        return makeHttpRequest(method: .post, serviceName: serviceName, headers: headers, isAdmin: true)
    }
    
    func getLeaderboard() -> ResponseData? {
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getLeaderboard
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
        
        var serviceName = ""
        if let favoriteTeam = currentUser.favorite_team {
            serviceName.append(favoriteTeam.lowercased())
        }
        return makeHttpRequest(method: .get, serviceName: serviceName, isNews: isReview ? false : true)
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
    
    func login(access_token: String) -> ResponseData? {
        
        let parameters: Parameters = [
            "access_token": access_token
        ]
        
        let serviceName = ServiceName.login
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
    
    func sendNotification(user_id: String, title: String, message: String, type: String, match_id: String) -> ResponseData? {
        let parameters = [
            "user_id": user_id,
            "title": title,
            "message": message,
            "type": type,
            "match_id": match_id
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.sendNotification
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers, isAdmin: true)
    }
    
    func sendPredictions(prediction: Prediction) -> ResponseData? {
        var parameters = [
            "user_id": prediction.user_id ?? "",
            "match_id": prediction.match_id ?? "",
            "home_score": prediction.home_score ?? "",
            "away_score": prediction.away_score ?? "",
            "status": prediction.status ?? "",
        ]
        
        parameters["winning_team"] = prediction.winning_team ?? ""
        parameters["date"] = prediction.date ?? ""
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]

        let serviceName = ServiceName.sendPredictions
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func updateActiveMatches(round: String) -> ResponseData? {
        let parameters = [
            "round": round
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.updateActiveMatches
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers, isAdmin: true)
    }
    
    func getReward(id: String, amount: String) -> ResponseData? {
        let parameters = [
            "reward_id": id,
            "reward_amount": amount
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.getReward
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    func purchaseCoins(id: String, amount: String) -> ResponseData? {
        let parameters = [
            "package_id": id,
            "package_amount": amount
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.purchaseCoins
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
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
    
    func updateFirebaseToken() {
        if firebaseToken != nil {
            let parameters: Parameters = [
                "firebase_token": firebaseToken
            ]
            
            let headers: HTTPHeaders = [
                "User-Id": USER_ID
            ]
            
            let serviceName = ServiceName.updateFirebaseToken
            _ = makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
        }
    }
    
    func updateMatchResult(match_id: String, winning_team: String, home_score: String, away_score: String) -> ResponseData? {
        let parameters: Parameters = [
            "match_id": match_id,
            "winning_team": winning_team,
            "home_score": home_score,
            "away_score": away_score
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.updateMatchResult
        return makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers, isAdmin: true)
    }
    
    func updateNotification(id: String) {
        let parameters: Parameters = [
            "id": id
        ]
        
        let headers: HTTPHeaders = [
            "User-Id": USER_ID
        ]
        
        let serviceName = ServiceName.updateNotification
        _ = makeHttpRequest(method: .post, serviceName: serviceName, parameters: parameters, headers: headers)
    }
    
    /************* SERVER REQUEST *************/
    
    private func makeHttpRequest(method: HTTPMethod, serviceName: String = "", parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, isConfig: Bool = false, isNews: Bool = false, isAdmin: Bool = false) -> ResponseData {
        
        var requestUrl = BaseUrl
        if isConfig {
            requestUrl = Services.ConfigUrl
        } else if isNews {
            requestUrl = Services._NewsUrl
        } else if isAdmin {
            requestUrl = Services._AdminUrl
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
    
    static func setNewsUrl(url: String) {
        _NewsUrl = url
    }
    
    static func setAdminUrl(url: String) {
        _AdminUrl = url
    }
}

