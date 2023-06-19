//
//  TAAuthProtocols.swift
//  MFAuthAccess_Example
//
//  Created by Nishu Sharma on 18/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

//MARK: TAAuthProtocols
public protocol TAAuthProtocols {
    init(webservice: WsHelperProtocol, authenticateUrl : String, startauthenticateUrl : String, resendPINUrl : String, controller : UIViewController)
    func InitialAuthetication(startAuthModel : TAAuthenticateStartRequest)
    func StartNextFactorAuthentoicationProcess(RequestModel:TAAuthenticateRequest)
    func TAResendPIN(RequestModel:TAResendPINRequest)
}
