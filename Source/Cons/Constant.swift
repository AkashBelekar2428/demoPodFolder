//
//  File.swift
//  MFTAAuthenticationFactors
//
//  Created by Akash Belekar on 14/06/23.
//

import Foundation

//MARK: Constant Properties
let Password_Minimun = 8
let Password_Maximum = 25

//MARK: UIAlertView property
public let App_Alert_Title = "Alert"

//MARK: UIAlertView Action
public let ok = "OK"
public let cancle = "Cancle"

//MARK: Username/Password
public let msg_blank_username = "Username cannot be blank"
public let msg_blank_password = "Password cannot be blank"
public let msg_invalid_username_Password = "Invalid Username / Password"
public let msg_invalid_username = "Invalid Username"

//MARK: Email/Password
public let msg_blank_emailAddress = "Email Address cannot be blank"
public let msg_invalid_emailAddress_Password = "Invalid Email Address / Password"

//MARK: Mobile Number
public let msg_blank_mobileNumber = "Please enter Mobile Number"
public let msg_less_10digit = "Please enter valid 10 digit Mobile Number"

//MARK: 6 digit PIN
public let msg_blank_6digit_PIN = "Please enter the 6 digit PIN"
public let msg_invalid_PIN = "Please enter valid PIN"

//MARK: Resend PIN
public let msg_resend_PIN = "We sent you a Text Message with 6 digit PIN"
public let msg_resend_previous_PIN = "Please enter valid PIN"
public let msg_resend_6digit_PIN = "We sent you an email with 6 digit PIN"
public let msg_previous_6digit_PIN = "Please enter valide PIN"

//MARK: Email
public let msg_invalid_email = "Please enter valid Email"

//MARK: Attempts More
public let msg_attempts_wrong_Password = "Your Account is locked. Unlock it by raising a support request."
public let msg_attempts_wrong_PIN = "Your Account is locked. Unlock it by raising a support request."
public let msg_attempts_resendPIN = "You have reached the max attempts for re-sending PIN. Please try logging in after some time."

//MARK: Password
public let msg_invalid_password = "Invalid Password"

//MARK: UIPicker (Country Dropdown)
public let countryArray = ["+1","+44","+91"]

//MARK: Error codes
public let code_Userlock = "E_USER_LOCKED"
