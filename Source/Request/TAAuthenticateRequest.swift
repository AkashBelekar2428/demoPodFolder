//
//  TAAuthenticateRequest.swift
//  MFAuthAccess_Example
//
//  Created by Nishu Sharma on 17/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


//{
//  "model": {
//    "clientId": "7f627b8a-d174-4679-bb37-4414afd34ee2",
//    "clientScope": "ottr-api"
//  }
//}


import Foundation
import ObjectMapper

//MARK: TAAuthenticateStartRequest Class
public class TAAuthenticateStartRequest : Mappable {
    
    //MARK: Variables
    public var model : TAAuthenticateStartModelObj!
    
    //MARK: init
    public init() {}
    required public init?(map: Map) {}
    public func mapping(map: Map){
        model   <- map["model"]
    }
}

//MARK: TAAuthenticateStartModelObj Class
public class TAAuthenticateStartModelObj : Mappable {
    
    //MARK: Variables
    public var clientId : String = ""
    public var clientScope : String = ""
    
    //MARK: init
    public init() {}
    
    required public init?(map: Map) {}
    public func mapping(map: Map){
        clientId          <- map["clientId"]
        clientScope       <- map["clientScope"]
    }
}
