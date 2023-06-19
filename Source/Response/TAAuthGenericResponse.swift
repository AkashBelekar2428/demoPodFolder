//
//  TAAuthGenericResponse.swift
//  MFAuthAccess_Example
//
//  Created by Nishu Sharma on 17/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Configure Enums


//    VERIFY_USERNAME_PASSWORD = 1,
//    VERIFY_EMAIL_PASSWORD = 2,
//    VERIFY_PASSWORD = 3,
//    VERIFIY_PHONENUMBER = 4,
//    VERIFY_PIN = 5,
//    VERIFY_EMAIL = 6,
//    AUTH_COMPLETE = 99


//    USERNAME_PASSWORD = 1,
//    EMAIL_PASSWORD =2,
//    MOBILE_PIN = 3,
//    EMAIL_PIN = 4

//MARK: TAAuthFactorType Enum
public enum TAAuthFactorType {
    case USERNAME_PASSWORD
    case EMAIL_PASSWORD
    case MOBILE_PIN
    case EMAIL_PIN
    case SIXDIGITPIN
    case NONE
}

//MARK: TAAuthFactorNextStep Enum
public enum TAAuthFactorNextStep {
    case VERIFY_USERNAME_PASSWORD
    case VERIFY_EMAIL_PASSWORD
    case VERIFY_PASSWORD
    case VERIFIY_PHONENUMBER
    case VERIFY_PIN
    case VERIFY_EMAIL
    case AUTH_COMPLETE
    case NONE
}

// MARK: Generic Response Model
public class TAAuthGenericResponse : Mappable {
    
    //MARK: Variables
    public var data : TAAuthGenericResponseDataObj!
    public var isError : Bool = false
    public var errorMessage : String = ""
    public var errorCode : String = ""
    public var errors : [String] = []
    public var validationErrors : [TAAuthGenericResponseValidationErrorsObj]!
    
    //MARK: init
    public init() {}
    required public init?(map: Map) {}
    public func mapping(map: Map){
        data                    <- map["data"]
        isError                 <- map["isError"]
        errorMessage            <- map["errorMessage"]
        errorCode               <- map["errorCode"]
        errors                  <- map["errors"]
        validationErrors        <- map["validationErrors"]
    }
}

// MARK: Data Response Model
public class TAAuthGenericResponseDataObj : Mappable {
    
    //MARK: Variables
    public var sessionId : String = ""
    public var nextStep : Int = -1
    public var token : TAAuthGenericResponseTokenObj!
    public var nextAuthFactor : Int = -1
    public var pendingRetryCount : Int = -1
    public var resendPinAfter : Int = -1
    
    public var username: String = ""
    public var email: String = ""
    public var phoneNumber:String = ""
    public var isReadonlyPrepopulatedValue: Bool = false
    
    public var nextStepEnum : TAAuthFactorNextStep = .NONE
    public var authType : TAAuthFactorType = .NONE
    public var componentType : TAAuthFactorType = .NONE

    
    //MARK: init
    public init() {}
    required public init?(map: Map) {}
    
    public func mapping(map: Map){
        sessionId                       <- map["sessionId"]
        nextStep                        <- map["nextStep"]
        token                           <- map["token"]
        nextAuthFactor                  <- map["nextAuthFactor"]
        pendingRetryCount               <- map["pendingRetryCount"]
        resendPinAfter                  <- map["resendPinAfter"]
        username                        <- map["userName"]
        email                           <- map["email"]
        phoneNumber                     <- map["phoneNumber"]
        isReadonlyPrepopulatedValue     <- map["isReadonlyPrepopulatedValue"]
    }
}

// MARK: Validation Errors Model
public class TAAuthGenericResponseTokenObj : Mappable {
    
    //MARK: Variables
    public var token : String = ""
    public var tokenExpiry : String = ""
    
    //MARK: init
    public init() {}
    required public init?(map: Map) {}
    
    public func mapping(map: Map){
        token                       <- map["token"]
        tokenExpiry                 <- map["tokenExpiry"]
    }
}

// MARK: Validation Errors Model
public class TAAuthGenericResponseValidationErrorsObj : Mappable {
    
    //MARK: Variables
    public var propertyName : String = ""
    public var errorMessage : String = ""
    
    //MARK: init
    public init() {}
    required public init?(map: Map) {}
    
    public func mapping(map: Map){
        propertyName                 <- map["propertyName"]
        errorMessage                 <- map["errorMessage"]
    }
}
