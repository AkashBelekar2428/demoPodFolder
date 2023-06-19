//
//  SendPINResponse.swift
//  MFUIAthentication
//
//  Created by Akash Belekar on 06/06/23.
//

import Foundation
import ObjectMapper


//MARK: TAResendPINRequest
public class TAResendPINRequest: Mappable{
    
    //MARK: Variables
    var model:AuthSessionIDResponse?
    
    //MARK: init
    public init() {}
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        model <- map["model"]
    }
}

//MARK: AuthSessionIDResponse
public class AuthSessionIDResponse:Mappable{
    
    //MARK: Variables
    var authSessionId : String = ""
    
    //MARK: init
    public init() {}
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        authSessionId <- map["authSessionId"]
    }
}
