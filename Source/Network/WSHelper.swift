//
//  WSHelper.swift
//  MFAuthAccess_Example
//
//  Created by Nishu Sharma on 18/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


import Foundation
import ObjectMapper
import Alamofire

//MARK: responseObject Enum
public enum responseObject{
    case success(Any)
    case failure(errorType,String)
    case sessionTimeOut(Any)
}

//MARK: errorType Enum
public enum errorType{
    case NoInternet
    case ServerError
    case ValidationError
    case sessionTimeOut
    case none
}

//MARK: Variables
let somethngWentWrng_Msg = "Something went wrong, please try later."
let No_Internet_Connection_Msg = "No Internet Connection.\nPlease check internet connection and try again!!"

//MARK: WSHelper Class
public class WSHelper: NSObject {
    
    //MARK: WSHelper Instance
    public static let sharedInstance = WSHelper()
    var isLive:Bool! = true
    
    //MARK: Init class
    private override init(){
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        super.init()
    }
    
    private func headers() -> HTTPHeaders{
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return headers
    }
    
    //MARK: Network status
    private func isNetworkReachable() -> Bool{
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            return false
        case .online(.wwan):
            return true
        case .online(.wiFi):
            return true
        }
    }
    
    //************************************ This is common method *************************************
    
    //MARK: WebServiceCall method
    
    /// <#Description#>
    /// - Parameters:
    ///   - api: <#api description#>
    ///   - httpType: <#httpType description#>
    ///   - dict: <#dict description#>
    ///   - completion: <#completion description#>
    private func WebServiceCall(api:String,httpType:HTTPMethod, dict:Parameters? ,completion: @escaping (responseObject) -> ()) {
        if isNetworkReachable(){
            var param = dict
            if param!.count == 0{
                param = nil
            }
            
            var session:RequestState!
            session = .live

            session.session.request(api, method: httpType, parameters: param , encoding: JSONEncoding.default, headers: headers())
                .response { response in
                    if response.data != nil{
                        switch response.response?.statusCode //SessionHandler.sharedInstance.checkSessionTimeOut(resp: response, statusCode: response.response!.statusCode)
                        {
                        case 200:
                            completion(.success(response))
                        case 1:
                            break
                        case 400:
                            completion(.failure(.ServerError, somethngWentWrng_Msg))
                        case 401:
                            completion(.sessionTimeOut(response))
                        default :
                            
                            let bodyString = String.init(data: response.data!, encoding: String.Encoding.utf8)!
                            let genericResp = Mapper<TAAuthGenericResponse>().map(JSONString: bodyString)
                            if genericResp != nil{
                                // get error message from response.data
                                completion(.failure(.ServerError, genericResp!.errorMessage))
                            } else {
                                completion(.failure(.ServerError, response.error != nil ?response.error!.localizedDescription:somethngWentWrng_Msg ))
                            }
                        }
                    } else {
                        if response.response != nil {
                            //                            let code = SessionHandler.sharedInstance.chekSessionTimedOutForResp(respCode:response.response!.statusCode)
                            let statusCode = response.response?.statusCode
                            if statusCode == 401 {
                                completion(.sessionTimeOut(response))
                            }
                            else
                            if statusCode == 400 {
                                completion(.failure(.ServerError, somethngWentWrng_Msg))
                            } else {
                                completion(.failure(.ServerError, response.error != nil ?response.error!.localizedDescription:somethngWentWrng_Msg ))
                            }
                        } else {
                            completion(.failure(.ServerError, response.error != nil ?response.error!.localizedDescription:somethngWentWrng_Msg ))
                        }
                    }
                }
        } else {
            completion(.failure(.NoInternet, No_Internet_Connection_Msg))
        }
    }
    
    //MARK: TAAuthetication remote call's
    
    public func GetSessionIdForAuthetication(api:String, requestModel:TAAuthenticateStartRequest, completion: @escaping (responseObject) -> ()) {
        let dict = requestModel.toJSON()
        WebServiceCall(api: api, httpType: .post, dict: dict) { (obj) in
            switch obj {
            case .success(let respObj):
                let resp = respObj as! AFDataResponse<Data?>
                let bodyString = String.init(data: resp.data!, encoding: String.Encoding.utf8)!
                let genResp = Mapper<TAAuthGenericResponse>().map(JSONString: bodyString)
                completion(.success(genResp!))
                break
            case .failure(let type, let msg):
                completion(.failure(type, msg))
                break
            case .sessionTimeOut(let respObj):
                completion(.sessionTimeOut(respObj))
            }
        }
    }
    
    public func Authenticate(api:String, requestModel:TAAuthenticateRequest, completion: @escaping (responseObject) -> ()) {
        let dict = requestModel.toJSON()
        WebServiceCall(api: api, httpType: .post, dict: dict) { (obj) in
            switch obj {
            case .success(let respObj):
                let resp = respObj as! AFDataResponse<Data?>
                let bodyString = String.init(data: resp.data!, encoding: String.Encoding.utf8)!
                let genResp = Mapper<TAAuthGenericResponse>().map(JSONString: bodyString)
                completion(.success(genResp!))
                break
            case .failure(let type, let msg):
                completion(.failure(type, msg))
                break
            case .sessionTimeOut(let respObj):
                completion(.sessionTimeOut(respObj))
            }
        }
    }
    public func ResendPIN(api:String, requestModel:TAResendPINRequest, completion:@escaping(responseObject) -> ()){
        let dic = requestModel.toJSON()
        WebServiceCall(api: api, httpType: .post, dict: dic) { (obj) in
            switch obj {
            case .success(let respObj):
                
                let resp = respObj as! AFDataResponse<Data?>
                let bodyString = String.init(data: resp.data!, encoding: String.Encoding.utf8)!
                let genResp = Mapper<TAResendPINResponse>().map(JSONString: bodyString)
                completion(.success(genResp!))
                break
            case .failure(let type,let msg):
                completion(.failure(type, msg))
                break
            case .sessionTimeOut(let respObj):
                completion(.sessionTimeOut(respObj))
            }
        }
    }
}

//MARK: GeneralRespModel Structure
public struct GeneralRespModel {
    let status: Bool!
    let respObj: Any!
    let message:String!
    let etype:errorType!
}

//MARK: RequestManager Class
public class RequestManager {
    public static let shared = RequestManager()
    fileprivate let liveManager: Session
    fileprivate let mockManager: Session
    
    public init() {
        
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            return configuration
        }()
        self.liveManager = Session.default
        self.mockManager = Session(configuration: configuration)
    }
}

//MARK: RequestState Enum
public enum RequestState {
    case live
    case mock
    
    public  var session: Session {
        switch self {
        case .live: return RequestManager.shared.liveManager
        case .mock: return RequestManager.shared.mockManager
        }
    }
}
