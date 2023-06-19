//
//  ValidationManager.swift
//  MFUIAthentication
//
//  Created by Akash Belekar on 30/05/23.
//

import Foundation

//MARK: ValidationClass 
public class ValidationClass {
    
    //MARK: Singletone
    static public let shared = ValidationClass()
    
    
    //MARK: UsernameValidations
    func validateUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z0-9_-]{6,}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
    //username
    public func isUsernameValid(username:String) -> (String,Bool) {
        
        let trimUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
       
        if trimUser.isEmpty == false{
            let userValid = isValidEmail(email: username)
            if userValid == true{
                return ("",true)
            }else{
                return(msg_invalid_username,false)
            }
        } else {
            return(msg_blank_username,false)
        }
    }
    
    
    //MARK: EmailValidations
    private func isValidEmail(email:String) -> Bool{
        let emailReg = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }
    
    //email
    public func isEmailValid(email:String) -> (String,Bool){
        
        let trimEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimEmail.isEmpty == false {
            let validateEmail = self.isValidEmail(email: email)
            if validateEmail == true {
                return ("",true)
            }else {
                return(msg_invalid_email,false)
            }
        } else {
            return(msg_blank_emailAddress,false)
        }
    }
    
    //MARK: PasswordValidations
    private func isValidPassword(password:String) -> Bool {
        let passwordReg = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,25}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordReg)
        return passwordTest.evaluate(with: password)
    }
    //password
    public func isPasswordValid(password:String) -> (String,Bool) {
        let trimPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimPassword.isEmpty == false{
            
            _ = self.isValidPassword(password: password)
            
            let passCount = password.count
            
            if (passCount >= Password_Minimun) && (passCount <= Password_Maximum) {
                return("",true)
            } else {
                return (msg_invalid_password,false)
            }
        } else {
            return (msg_blank_password,false)
        }
    }
    
    //MARK: PhoneValidations
    public func isPhoneValid(phone:String) -> (String,Bool){
        
        let trimPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimPhone.isEmpty == false {
            if trimPhone.count == 10 {
                return ("",true)
            } else {
                return (msg_less_10digit,false)
            }
        } else {
            return (msg_blank_mobileNumber,false)
        }
    }
    

    //MARK: PINValidations
    public func isPINValid(pin:String) -> (String,Bool){
        
        let trimPIN = pin.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimPIN.isEmpty == false{
            if trimPIN.count == 6{
                return ("",true)
            }else{
                return(msg_blank_6digit_PIN,false)
            }
        }else{
            return(msg_blank_6digit_PIN,false)
        }
    }
}
