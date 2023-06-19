//
//  AuthenticationConfiguration.swift
//  MFAuthAccess
//
//  Created by Akash Belekar on 09/05/23.
//

import Foundation

//MARK: AuthenticationConfiguration class
public class AuthenticationConfiguration{
    
    //MARK: Auth Variables
    public var loginLbl = TALable()
    public var tfView = TAUIView()
    public var authLbl = TALable()
    public var passwordLbl = TALable()
    public var iconLbl = TALable()
    public var iconEyeBtn = TAButton()
    public var enterValidAuthLbl = TALable()
    public var enterValidPasswordLBl = TALable()
    public var firstTextfiled = TATextFiled()
    public var secondTextfiled = TATextFiled()
    public var validBtn = TAButton()
    public var forgotPasswordBtn = TAButton()
    public var logoImage = TAImage()
    public var containerViewShow = TAUIView()
    public var countryCodeBtn = TAButton()
    public var color = TAColor()
    
    //MARK: PIN variables
    public var pinDescription = TALable()
    public var PinLbl = TALable()
    public var enterValidPin = TALable()
    public var resendBtn = TAButton()
    
    //MARK: Email Variables
    public var emailLbl = TALable()
    public var enterValidEmail = TALable()
    public var emailIcon = TALable()
    public var passwordIcon = TALable()
    public var eyeIcon = TAButton()
    
    //MARK: Mobile Variables
    public var mobileLbl = TALable()
    public var enterValidMobileNumber = TALable()
    public var countryCountryLbl = TALable()
    public var countryCodeView = TAUIView()
    public var countryCodeIcon = TALable()

    public var viewType: AuthType = .none
    
    public init() {}
}

//MARK: AuthType Enum
public enum AuthType {
    case pinView, email, mobile, authLog, none
}

