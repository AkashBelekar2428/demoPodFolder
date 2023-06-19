//
//  ComponentManager.swift
//  MFUIAthentication
//
//  Created by Akash Belekar on 30/05/23.
//

import Foundation

//MARK: ComponentManagerDelegate Protocol
public protocol ComponentManagerDelegate {
    func sendPinBtnAction(email: String, password: String)
    func sendPINBtnAction(email:String)
    func sendPINAction(mobileNumber:String)
    func validateBtnAction(pinNumber: String)
    func resendPINAction()
    func resetAuthFactors()
}

//MARK:  ComponentManager Class
public class ComponentManager{
    //MARK: init
    public init(delegate: ComponentManagerDelegate) {
        self.delegate = delegate
    }
    
    //MARK: Variables
    private var enum_authType: TAAuthFactorType = .NONE
    private var enum_nextStep: TAAuthFactorNextStep = .NONE
    private var enum_componentType: TAAuthFactorType = .NONE
    private var respObj = TAAuthGenericResponseDataObj.init()
    public var delegate : ComponentManagerDelegate?
    
    //MARK: Tag
    public var tagForComponent : Int {
        get {
            return 4444
        }
    }
    
    //MARK: configureComponentFactorwise
    public func configureComponentFactorwise(nextStep:Int, authFactor:Int,respObj:TAAuthGenericResponseDataObj) -> UIView? {
        
        SetAuthNextStep(nextStep: nextStep)
        SetAuthFactorType(authFactor: authFactor)
        SetComponentType(authFactor: self.enum_authType, nextStep: self.enum_nextStep)
        self.respObj = respObj
        return ConfigureUI(type: self.enum_componentType)
    }
    
    //MARK: Enum-Configuration AuthFactorType
    private func SetAuthFactorType(authFactor : Int) {
        if authFactor == 1 {
            enum_authType = .USERNAME_PASSWORD
        } else if authFactor == 2 {
            enum_authType = .EMAIL_PASSWORD
        } else if authFactor == 3 {
            enum_authType = .MOBILE_PIN
        } else if authFactor == 4 {
            enum_authType = .EMAIL_PIN
        } else {
            enum_authType = .NONE
        }
    }
    
    //MARK: Enum-Configuration AuthNextStep
    private func SetAuthNextStep(nextStep : Int) {
       
        if nextStep == 1 {
            enum_nextStep = .VERIFY_USERNAME_PASSWORD
        } else if nextStep == 2 {
            enum_nextStep = .VERIFY_EMAIL_PASSWORD
        } else if nextStep == 3 {
            enum_nextStep = .VERIFY_PASSWORD
        } else if nextStep == 4 {
            enum_nextStep = .VERIFIY_PHONENUMBER
        } else if nextStep == 5 {
            enum_nextStep = .VERIFY_PIN
        } else if nextStep == 6 {
            enum_nextStep = .VERIFY_EMAIL
        } else if nextStep == 99 {
            enum_nextStep = .AUTH_COMPLETE
        } else {
            enum_nextStep = .NONE
        }
    }
    
    //MARK: Enum-Configuration ComponentType
    private func SetComponentType(authFactor :TAAuthFactorType ,nextStep: TAAuthFactorNextStep){
        if authFactor == .USERNAME_PASSWORD {
            if nextStep == .VERIFY_USERNAME_PASSWORD || nextStep == .VERIFY_PASSWORD {
                enum_componentType = .USERNAME_PASSWORD
            } else if nextStep == .VERIFY_PIN {
                enum_componentType = .SIXDIGITPIN
            } else {
                enum_componentType = .NONE
            }
        } else if authFactor == .EMAIL_PASSWORD {
            if nextStep == .VERIFY_EMAIL_PASSWORD || nextStep == .VERIFY_PASSWORD {
                enum_componentType = .EMAIL_PASSWORD
            } else if nextStep == .VERIFY_PIN {
                enum_componentType = .SIXDIGITPIN
            } else {
                enum_componentType = .NONE
            }
        } else if authFactor == .MOBILE_PIN {
            if nextStep == .VERIFIY_PHONENUMBER {
                enum_componentType = .MOBILE_PIN
            } else if nextStep == .VERIFY_PIN {
                enum_componentType = .SIXDIGITPIN
            } else {
                enum_componentType = .NONE
            }
        } else if authFactor == .EMAIL_PIN {
            if nextStep == .VERIFY_EMAIL {
                enum_componentType = .EMAIL_PIN
            } else if nextStep == .VERIFY_PIN {
                enum_componentType = .SIXDIGITPIN
            } else {
                enum_componentType = .NONE
            }
        } else {
            enum_componentType = .NONE
        }
    }
    
    //MARK: ConfigureUI
    private func ConfigureUI(type : TAAuthFactorType) -> UIView? {
        var prepopulate = ""

        if type == .USERNAME_PASSWORD || type == .EMAIL_PASSWORD {
            
                if respObj.isReadonlyPrepopulatedValue == true {
                    
                    if type == .USERNAME_PASSWORD || type == .EMAIL_PASSWORD{
                        prepopulate = self.respObj.username
                    }
                    else{
                        prepopulate = self.respObj.email
                    }
                }else{
                    prepopulate = ""
                }
          
            var view : UIView {
                get {
                    let UsernamePasswordUI = AuthenticationLogIn()
                    UsernamePasswordUI.tag = self.tagForComponent
                    UsernamePasswordUI.authType = type
                    UsernamePasswordUI.prepopulateValue = prepopulate
                    UsernamePasswordUI.delegate = self
                    UsernamePasswordUI.setDefaultThems()
                    return UsernamePasswordUI
                }
            }
            return view
        }
        else
        if type == .EMAIL_PIN{
            var view : UIView {
                get {
                    let emailPasswordUI = Email_Address()
                    emailPasswordUI.setEmailDefaultThemes()
                    emailPasswordUI.tag = self.tagForComponent
                    emailPasswordUI.delegate = self
                    return emailPasswordUI
                }
            }
            return view
        }
        else
        if type == .SIXDIGITPIN {
            var maskingPIN = ""
            
            if enum_authType == .EMAIL_PASSWORD || enum_authType == .EMAIL_PIN {
                maskingPIN = self.respObj.email
            } else if enum_authType == .MOBILE_PIN {
                maskingPIN = self.respObj.phoneNumber
            }else{
                maskingPIN = ""
            }
            var view : UIView {
                get {
                    let pinUI = PINView()
                    pinUI.tag = self.tagForComponent
                    pinUI.maskingForValue = maskingPIN
                    pinUI.authTypes = enum_authType
                    pinUI.resendPINCounter = respObj.pendingRetryCount
                    pinUI.resendPINTimerSecond = respObj.resendPinAfter
                    pinUI.delegate = self
                    pinUI.setPINDefaultThemes()
                    pinUI.startResendPinTimer()
                    return pinUI
                }
            }
            return view
        }
        else
        if type == .MOBILE_PIN
        {
            var view : UIView {
                get {
                    let MobileUI = Mobile_Number()
                    MobileUI.tag = self.tagForComponent
                    MobileUI.setMobileDefaultThemes()
                    MobileUI.delegate = self
                    return MobileUI
                }
            }
            return view
        } else {
            return UIView()
        }
    }
}

//MARK: Extension AuthenticationLogInDelegate
extension ComponentManager : AuthenticationLogInDelegate {
    public func validAuthBtnActionDelegate(email: String, password: String) {
        delegate?.sendPinBtnAction(email: email, password: password)
    }
}

//MARK: Extension EmailAddressDelegate
extension ComponentManager : EmailAddressDelegate{
    public func validEmailBtnActionDelegate(email: String) {
        delegate?.sendPINBtnAction(email: email)
    }
}

//MARK: Extension PINViewDelegate
extension ComponentManager : PINViewDelegate{
    public func validPINBtnActionDelegate(pinNumber: String) {
        delegate?.validateBtnAction(pinNumber: pinNumber)
    }
    
    public func resestAuthfactor() {
        delegate?.resetAuthFactors()
    }
    
    public func resendPIN() {
        delegate?.resendPINAction()
    }
}

//MARK: Extension MobileNumberDelegate
extension ComponentManager : MobileNumberDelegate{
    public func validMobileBtnActionDelegate(mobileNumber: String) {
        delegate?.sendPINAction(mobileNumber: mobileNumber)
    }
}
