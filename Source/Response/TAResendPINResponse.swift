//
//  TAResendPINResponse.swift
//  MFUIAthentication
//
//  Created by Akash Belekar on 06/06/23.
//

import Foundation
import ObjectMapper


//MARK: TAResendPINResponse
public class TAResendPINResponse:Mappable{
    
    //MARK: Variables
    var data : Bool = false
    var isError : Bool = false
    var errorMessage : String = ""
    var errorCode : String = ""
    var errors : [String] = []
    var validationErrors:[TAValidationtionErrorsResponse]!
    
    //MARK: init
    public init() {}
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        data              <- map["data"]
        isError           <- map["isError"]
        errorMessage      <- map["errorMessage"]
        errorCode         <- map["errorCode"]
        errors            <- map["errors"]
        validationErrors  <- map["validationErrors"]
        
    }
}

//MARK: TAValidationtionErrorsResponse
public class TAValidationtionErrorsResponse:Mappable{
    
    //MARK: Variables
    var propertyName : String = ""
    var errorMessage : String = ""
    
    //MARK: init
    public init() {}
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        propertyName    <- map["propertyName"]
        errorMessage    <- map["errorMessage"]
    }
}
