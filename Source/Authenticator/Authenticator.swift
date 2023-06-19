//
//  MiddleLayer.swift
//  MFAuthAccess_Example
//
//  Created by Nishu Sharma on 18/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD

//MARK: TAMultiAuthFactorSuccess Protocol
public protocol TAMultiAuthFactorSuccess : AnyObject {
    func TAAuthFactorCompletedWithToken(token: TAAuthGenericResponseTokenObj)
}

//MARK: Class MiddleLayer
public class Authenticator : TAAuthProtocols {
    
    //MARK: Variables
    var webservice : WsHelperProtocol!
    var authenticateUrl : String = ""
    var startauthenticateUrl : String = ""
    var resendPINUrl : String = ""
    var TAAuthRespObj : TAAuthGenericResponse?
    var controller : UIViewController?
    private var startAuthModel : TAAuthenticateStartRequest?
    private var genericAuthRequest : TAAuthenticateRequest?
    public var resendPINRequest : TAResendPINRequest?
    public weak var delegate : TAMultiAuthFactorSuccess?
    public var authTypes:TAAuthFactorType?
    
    private var pinView = PINView()
    private var resendPinCounter = 0
    
    //MARK: Tag
    private var tagForComponent : Int {
        get {
            return 4444
        }
    }
    
    //MARK: init
    required public init(webservice: WsHelperProtocol, authenticateUrl : String, startauthenticateUrl : String, resendPINUrl : String, controller : UIViewController) {
        self.webservice = webservice
        self.authenticateUrl = authenticateUrl
        self.startauthenticateUrl = startauthenticateUrl
        self.controller = controller
        self.resendPINUrl = resendPINUrl
    }
    
    //MARK: InitialAuthetication Method
    public func InitialAuthetication(startAuthModel : TAAuthenticateStartRequest) {
        showLoader()
        self.startAuthModel = startAuthModel
        self.webservice.GetSessionIdForAuthetication(api: self.startauthenticateUrl, requestModel: startAuthModel) { resp in
            self.ResponseManager(resp: resp, isCallAutheticate: false)
        }
    }
    
    //MARK: NextFactorAuthentication Method
    public func StartNextFactorAuthentoicationProcess(RequestModel:TAAuthenticateRequest) {
        showLoader()
        self.genericAuthRequest = RequestModel
        self.webservice.Authenticate(api: self.authenticateUrl, requestModel: RequestModel) { resp in
            self.ResponseManager(resp: resp, isCallAutheticate: true)
        }
    }
    public func TAResendPIN(RequestModel: TAResendPINRequest) {
        showLoader()
        self.resendPINRequest = RequestModel
        webservice.ResendPIN(api: self.resendPINUrl, requestModel: RequestModel) { res in
            self.ResponseManager(resp: res, isCallAutheticate: true)
        }
    }
    
    //MARK: ResponseManager Method
    private func ResponseManager(resp : GeneralRespModel?, isCallAutheticate : Bool) {
        
        if resp?.status == true {
            if let genericResp = resp?.respObj as? TAAuthGenericResponse {
                if genericResp.isError == false {
                    if genericResp.data != nil {
                        self.TAAuthRespObj = genericResp
                        self.ConfigureTypesAndSetComponent()
                    } else{
                        AlertManager.shared.showAlert(title: "Alert", msg: "No data found.", action: "OK", viewController: self.controller ?? UIViewController())
                        hideLoader()
                    }
                }else {
                    // show alert with errorMessage
                    if genericResp.errorCode == code_Userlock {
                        self.navigateToFirstAuth(msg: genericResp.errorMessage)
                        
                    }else{
                        AlertManager.shared.showAlert(title: "Alert", msg: genericResp.errorMessage, action: "OK", viewController: self.controller ?? UIViewController())
                    }
                    hideLoader()
                }
            }else if let pinResponse = resp?.respObj as? TAResendPINResponse{
                if pinResponse.isError == false {
                    if pinResponse.data == true {
                        print("----Success Response----")
                        pinView.btnResendPin.isHidden = true
                        
                       
                        if TAAuthRespObj?.data.authType == .MOBILE_PIN{
                            AlertManager.shared.showAlert(title: "Alert", msg: "We sent you a Text Message with 6-Digit PIN", action: "OK", viewController: self.controller ?? UIViewController())
                          
                        }else{
                            AlertManager.shared.showAlert(title: "Alert", msg: "We sent you an email with 6-Digit PIN", action: "OK", viewController: self.controller ?? UIViewController())
                           
                        }
                        pinView.resendPINCounter -= 1
                        pinView.startResendPinTimer()
                        hideLoader()
                        
                    }else{
                        AlertManager.shared.showAlert(title: "Alert", msg: pinResponse.errorMessage, action: "OK", viewController: self.controller ?? UIViewController())
                        hideLoader()
                    }
                }
            }
        }  else  {
            if resp?.etype == .ServerError {
                // show server error message
                AlertManager.shared.showAlert(title: "Alert", msg: resp?.message ?? somethngWentWrng_Msg, action: "OK", viewController: self.controller ?? UIViewController())
            }
            else
            if resp?.etype == .sessionTimeOut {
                self.navigateToFirstAuth(msg: "Session timeout !!")
                // navigate to first page
                
            }  else
            if resp?.etype == .NoInternet {
                AlertManager.shared.showAlertsActions(title: "Alert", msg: "No internet connection !!", firstAction: "Retry", secondAction: "Cancel", firstCompletion: {
                    if isCallAutheticate == true {
                        self.StartNextFactorAuthentoicationProcess(RequestModel: self.genericAuthRequest!)
                    } else {
                        self.InitialAuthetication(startAuthModel: self.startAuthModel!)
                    }
                    
                }, secondCompletion: {
                    
                }, viewController: self.controller!)
            }
            hideLoader()
        }
    }
    
    private func navigateToFirstAuth(msg:String){
        AlertManager.shared.showSingleAlert(title: "Alert", msg: msg, action: "OK", firstCompletion: {
            self.InitialAuthetication(startAuthModel: self.startAuthModel!)
        }, viewController: self.controller ?? UIViewController())
    }
    
    
    //MARK: ConfigureTypesAndSetComponent
    private func ConfigureTypesAndSetComponent() {
        let dataObj = self.TAAuthRespObj?.data
        
        self.SetAuthFactorType(authFactor: (self.TAAuthRespObj?.data.nextAuthFactor) ?? 0)
        self.SetAuthNextStep(nextStep: (self.TAAuthRespObj?.data.nextStep) ?? 0)
        self.SetComponentType(authFactor: dataObj!.authType, nextStep: dataObj!.nextStepEnum)
        
        print("Factor ==> \(String(describing: self.TAAuthRespObj?.data.nextStepEnum))")
        print("Type ==> \(String(describing: self.TAAuthRespObj?.data.authType))")
        
        if self.TAAuthRespObj?.data.nextStepEnum == .AUTH_COMPLETE {
            if self.TAAuthRespObj?.data.token != nil {
                hideLoader()
                self.delegate?.TAAuthFactorCompletedWithToken(token: (self.TAAuthRespObj?.data.token)!)
            } else {
                self.InitialAuthetication(startAuthModel: self.startAuthModel!)
            }
        } else {
            self.AddComponentFactorWise()
        }
    }
    
    //MARK: AddComponentFactorWise
    private func AddComponentFactorWise() {
        let type = self.TAAuthRespObj?.data.componentType ?? .NONE
        if let view = self.ConfigureUI(type: type) {
            if let controller = controller {
                controller.view.addSubview(view)
                pinView = .init()
                if view.isKind(of: PINView.self) {
                    if let pView = view as? PINView {
                        pinView = pView
                    }
                }
            }
        }
        hideLoader()
    }
    
    //MARK: Enum-Configurations AuthFactorType
    private func SetAuthFactorType(authFactor : Int) {
        let obj = self.TAAuthRespObj?.data
        if authFactor == 1 {
            obj?.authType = .USERNAME_PASSWORD
        } else if authFactor == 2 {
            obj?.authType = .EMAIL_PASSWORD
        } else if authFactor == 3 {
            obj?.authType = .MOBILE_PIN
        } else if authFactor == 4 {
            obj?.authType = .EMAIL_PIN
        } else {
            obj?.authType = .NONE
        }
    }
    
    //MARK: Enum-Configurations AuthNextStep
    private func SetAuthNextStep(nextStep : Int) {
        let obj = self.TAAuthRespObj?.data
        if nextStep == 1 {
            obj?.nextStepEnum = .VERIFY_USERNAME_PASSWORD
        } else if nextStep == 2 {
            obj?.nextStepEnum = .VERIFY_EMAIL_PASSWORD
        } else if nextStep == 3 {
            obj?.nextStepEnum = .VERIFY_PASSWORD
        } else if nextStep == 4 {
            obj?.nextStepEnum = .VERIFIY_PHONENUMBER
        } else if nextStep == 5 {
            obj?.nextStepEnum = .VERIFY_PIN
        } else if nextStep == 6 {
            obj?.nextStepEnum = .VERIFY_EMAIL
        } else if nextStep == 99 {
            obj?.nextStepEnum = .AUTH_COMPLETE
        } else {
            obj?.nextStepEnum = .NONE
        }
    }
    
    //MARK: Configurations ComponentType
    private func SetComponentType(authFactor :TAAuthFactorType ,nextStep: TAAuthFactorNextStep){
        if authFactor == .USERNAME_PASSWORD {
            if nextStep == .VERIFY_USERNAME_PASSWORD || nextStep == .VERIFY_PASSWORD {
                self.TAAuthRespObj?.data.componentType = .USERNAME_PASSWORD
            } else if nextStep == .VERIFY_PIN {
                self.TAAuthRespObj?.data.componentType = .SIXDIGITPIN
            } else {
                self.TAAuthRespObj?.data.componentType = .NONE
            }
        } else if authFactor == .EMAIL_PASSWORD {
            if nextStep == .VERIFY_EMAIL_PASSWORD || nextStep == .VERIFY_PASSWORD {
                self.TAAuthRespObj?.data.componentType = .EMAIL_PASSWORD
            } else if nextStep == .VERIFY_PIN {
                self.TAAuthRespObj?.data.componentType = .SIXDIGITPIN
            } else {
                self.TAAuthRespObj?.data.componentType = .NONE
            }
        } else if authFactor == .MOBILE_PIN {
            if nextStep == .VERIFIY_PHONENUMBER {
                self.TAAuthRespObj?.data.componentType = .MOBILE_PIN
            } else if nextStep == .VERIFY_PIN {
                self.TAAuthRespObj?.data.componentType = .SIXDIGITPIN
            } else {
                self.TAAuthRespObj?.data.componentType = .NONE
            }
        } else if authFactor == .EMAIL_PIN {
            if nextStep == .VERIFY_EMAIL {
                self.TAAuthRespObj?.data.componentType = .EMAIL_PIN
            } else if nextStep == .VERIFY_PIN {
                self.TAAuthRespObj?.data.componentType = .SIXDIGITPIN
            } else {
                self.TAAuthRespObj?.data.componentType = .NONE
            }
        } else {
            self.TAAuthRespObj?.data.componentType = .NONE
        }
    }
    
    //MARK: ConfigureUI
    private func ConfigureUI(type : TAAuthFactorType) -> UIView? {
        
        if let taggedView = self.controller?.view.viewWithTag(self.tagForComponent) {
            taggedView.removeFromSuperview()
        }
        
        let compManager = ComponentManager.init(delegate: self)
        
        let nextStep = (self.TAAuthRespObj?.data.nextStep)!
        let factor = (self.TAAuthRespObj?.data.nextAuthFactor)!
        let viewfactorwise = compManager.configureComponentFactorwise(nextStep: nextStep, authFactor: factor, respObj:(self.TAAuthRespObj?.data!)!)
        viewfactorwise?.tag = self.tagForComponent
        viewfactorwise?.frame = (self.controller?.view.frame)!
        
        return viewfactorwise
    }
    
    //MARK: Loader Show
    func showLoader(){
        SVProgressHUD.show()
        self.controller?.view.isUserInteractionEnabled = false
    }
    
    //MARK: Loader Hide
    func hideLoader(){
        SVProgressHUD.dismiss()
        self.controller?.view.isUserInteractionEnabled = true
    }
}

//MARK:  MiddleLayer Extension
extension Authenticator : ComponentManagerDelegate {
    public func resetAuthFactors() {
        InitialAuthetication(startAuthModel: startAuthModel!)
    }
    //MARK: Set ComponentManagerDelegate
    public func sendPinBtnAction(email: String, password: String) {
        print("EMAIL ==> \(email)")
        print("PASSWORD ==> \(password)")
        
        let dataObj = TAAuthRespObj?.data
        
        let isUserNamePasswordComp = dataObj?.componentType == .USERNAME_PASSWORD
        
        let requestObj = TAAuthenticateRequest.init()
        let modelObj = TAAuthenticateRequestModelObj.init()
        modelObj.password = password
        modelObj.email = isUserNamePasswordComp == true ? "" : email
        modelObj.userName = isUserNamePasswordComp == true ? email : ""
        modelObj.authFactorType = dataObj!.nextAuthFactor
        modelObj.currentAuthStep = dataObj!.nextStep
        modelObj.authSessionId = dataObj!.sessionId
        requestObj.model = modelObj
        self.StartNextFactorAuthentoicationProcess(RequestModel: requestObj)
    }
    
    public func sendPINBtnAction(email: String) {
        print("EMAIL ID ==> \(email)")
        let dataObj = TAAuthRespObj?.data
        let requestObj = TAAuthenticateRequest.init()
        let modelObj = TAAuthenticateRequestModelObj.init()
        modelObj.email = email
        modelObj.authFactorType = dataObj!.nextAuthFactor
        modelObj.currentAuthStep = dataObj!.nextStep
        modelObj.authSessionId = dataObj!.sessionId
        requestObj.model = modelObj
        self.StartNextFactorAuthentoicationProcess(RequestModel: requestObj)
    }
    
    public func sendPINAction(mobileNumber: String) {
        print("PHONE NUMBER ==> \(mobileNumber)")
        
        let dataObj = TAAuthRespObj?.data
        let requestObj = TAAuthenticateRequest.init()
        let modelObj = TAAuthenticateRequestModelObj.init()
        modelObj.phoneNumber = "\(mobileNumber.replacingOccurrences(of: "+", with: ""))"
        modelObj.authFactorType = dataObj!.nextAuthFactor
        modelObj.currentAuthStep = dataObj!.nextStep
        modelObj.authSessionId = dataObj!.sessionId
        requestObj.model = modelObj
        self.StartNextFactorAuthentoicationProcess(RequestModel: requestObj)
    }
    
    public func validateBtnAction(pinNumber: String) {
        print("PING VIEW ==> \(pinNumber)")
        let dataObj = TAAuthRespObj?.data
        let requestObj = TAAuthenticateRequest.init()
        let modelObj = TAAuthenticateRequestModelObj.init()
        modelObj.pin = pinNumber
        modelObj.authFactorType = dataObj!.nextAuthFactor
        modelObj.currentAuthStep = dataObj!.nextStep
        modelObj.authSessionId = dataObj!.sessionId
        requestObj.model = modelObj
        self.StartNextFactorAuthentoicationProcess(RequestModel: requestObj)
    }
    public func resendPINAction() {
        let dataObj = TAAuthRespObj?.data
        let RequestModel = TAResendPINRequest.init()
        let model = AuthSessionIDResponse.init()
        model.authSessionId = dataObj!.sessionId
        RequestModel.model = model
        self.TAResendPIN(RequestModel: RequestModel)
    }
}
