//
//  AuthView.swift
//  Reusable
//
//  Created by Akash Belekar on 26/04/23.
//

import UIKit

//MARK: Protocol AuthenticationLogInDelegate
public protocol AuthenticationLogInDelegate{
    func validAuthBtnActionDelegate(email: String, password: String)
}

//MARK: AuthenticationLogIn Class
public class AuthenticationLogIn: UIView{
    
    //MARK: @IBOutlets
    @IBOutlet weak public var viewContainerAuth:UIView!
    @IBOutlet weak public var imgLogo:UIImageView!
    @IBOutlet weak public var lblLogin:UILabel!
    @IBOutlet weak public var lblAuthType:UILabel!
    @IBOutlet weak public var viewAuthType:UIView!
    @IBOutlet weak public var lblEmailIcon:UILabel!
    @IBOutlet weak public var tfEmail:UITextField!
    @IBOutlet weak public var lblEnterValidAuth:UILabel!
    @IBOutlet weak public var lblPassword:UILabel!
    @IBOutlet weak public var viewPassword:UIView!
    @IBOutlet weak public var lblPasswordIcon:UILabel!
    @IBOutlet weak public var tfPassword:UITextField!
    @IBOutlet weak public var btnEyeIcon:UIButton!
    @IBOutlet weak public var lblEnterValidePassword:UILabel!
    @IBOutlet weak public var btnForgotPassword:UIButton!
    @IBOutlet weak public var btnValidate:UIButton!
    @IBOutlet weak public var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak public var lblEnterValidEmailHeight: NSLayoutConstraint!
    @IBOutlet weak public var lblEnterValidPasswordHeight: NSLayoutConstraint!
    
    //MARK: Variables
    let nibName = "AuthenticationLogIn"
    public var delegate:AuthenticationLogInDelegate?
    public var authConfig = AuthenticationConfiguration()
    
    public weak var controller: UIViewController?
    public var authType : TAAuthFactorType = .NONE
    public var prepopulateValue = ""
    
    
    //MARK: System methods
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    //MARK: Custom methods
    func commonInit(){
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        tfEmail.delegate = self
        tfPassword.delegate = self
        self.addSubview(view)
        self.viewContainerAuth.isHidden = true
    }
    
    func loadViewFromNib() -> UIView?{
        let bundel = Bundle(for: AuthenticationLogIn.self)
        let nib = bundel.loadNibNamed(nibName, owner: self)?.first as? UIView
        return nib
    }

    //MARK: SetDefaultThems
    public func setDefaultThems(){
        let config = self.themsConfiguration()
        setThemWithAuthConfiguration(config: config)
    }
    
    //MARK: Configure DefaultThems
    func themsConfiguration() -> AuthenticationConfiguration{
        let authConfigObj = AuthenticationConfiguration()
        let imgLogo = TAImage()
        let lblLogin = TALable()
        let lblAuthType = TALable()
        let lblPassword = TALable()
        let lblEnterValidEmail = TALable()
        let lblEnterValidPassword = TALable()
        let viewTestfiled = TAUIView()
        let tfFirst = TATextFiled()
        let tfSecond = TATextFiled()
        let btnForgotPassword = TAButton()
        let btnValid = TAButton()
        let containerView = TAUIView()
        let emailIcon = TALable()
        let passwordIcon = TALable()
        let eyeIcon = TAButton()
        
        //MARK: Configuration for Icons
        setThemsForFont(FontClass: TAFontIcon.self)
        
        if  authType == .USERNAME_PASSWORD {
            emailIcon.TAText =  TAFontIcon.TA_Icon_user
        }  else{
            emailIcon.TAText = TAFontIcon.TA_Icon_mail
        }
        
        emailIcon.TATextColor = TAFontIcon.TATextColor
        emailIcon.TATextFont = UIFont(name: "authentication_font_file", size: 20)!
        
        setThemsForFont(FontClass: TAFontIcon.self)
        passwordIcon.TAText = TAFontIcon.TA_Icon_lock
        passwordIcon.TATextColor = TAFontIcon.TATextColor
        passwordIcon.TATextFont =  UIFont(name: "authentication_font_file", size: 20)!
        
        setThemsForFont(FontClass: TAFontIcon.self)
        eyeIcon.TABtnTitleText = TAFontIcon.TA_Icon_eye_off
        eyeIcon.TABtnTitleTextColor = TAFontIcon.TAEyeIconColor
        eyeIcon.TABtnTitleTextFont =  UIFont(name: "authentication_font_file", size: 20)!
        eyeIcon.TABtnBackgrounColor = .white
        
        
        //MARK: Configuration for Image Logo
        if let image = UIImage(named: "logo",in: Bundle(for:TAAssetsImage.self ),compatibleWith: nil){
            imgLogo.TAImageLogo = image
        }
        
        //MARK: Configuration for Login Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Bold")
        lblLogin.TAText = "Login"
        lblLogin.TATextColor = TAColor.TATextLblColor
        lblLogin.TATextAlignment = .left
        lblLogin.TATextNumberOfLines = 0
        lblLogin.TATextFont = TAFontIcon.TAFontBold
        
        //MARK: Configuration for Email Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        if authType == .USERNAME_PASSWORD{
            lblAuthType.TAText = "Username"
        }else{
            lblAuthType.TAText = "Email"
        }
        lblAuthType.TATextColor = TAColor.TATextLblColor
        lblAuthType.TATextFont =  TAFontIcon.TAFontMedium
        lblAuthType.TATextAlignment = .left
        lblAuthType.TATextNumberOfLines = 0
        
        //MARK: Configuration for Password Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        lblPassword.TAText = "Password"
        lblPassword.TATextColor = TAColor.TATextLblColor
        lblPassword.TATextFont = TAFontIcon.TAFontMedium
        lblPassword.TATextAlignment = .left
        lblPassword.TATextNumberOfLines = 0
        
        //MARK: Configuration for Enter Valid Email Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Regular")
        lblEnterValidEmail.TAText = ""
        lblEnterValidEmail.TATextColor = TAColor.TAValidAuthColor
        lblEnterValidEmail.TATextFont = TAFontIcon.TAFontRegularErrMsg
        lblEnterValidEmail.TATextAlignment = .left
        lblEnterValidEmail.TATextNumberOfLines = 0
     
        //MARK: Configuration for Enter Valid Password Lebel
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Regular")
        lblEnterValidPassword.TAText = ""
        lblEnterValidPassword.TATextColor = TAColor.TAValidAuthColor
        lblEnterValidPassword.TATextFont =  TAFontIcon.TAFontRegularErrMsg
        lblEnterValidPassword.TATextAlignment = .left
        lblEnterValidPassword.TATextNumberOfLines = 0
        
        //MARK: Configuration for tfView
        viewTestfiled.TAViewCornerRadius = 5
        viewTestfiled.TAViewborderWidth = 1
        viewTestfiled.TAViewBorderColor = TAColor.TAPlaceholderText_borderColor
  
        
        //MARK: Configuration for Textfiled placeHolder
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        if  authType == .USERNAME_PASSWORD {
            tfFirst.TATextfiledPlaceHolderText = "abc"
            
            if !prepopulateValue.isEmpty{
                tfFirst.TATfText = prepopulateValue
                tfEmail.isUserInteractionEnabled = false
            }else{
                tfEmail.isUserInteractionEnabled = true
            }
        }  else {
            tfFirst.TATextfiledPlaceHolderText = "abc@yourdomain.com"
            
            if !prepopulateValue.isEmpty{
                tfFirst.TATfText = prepopulateValue
                tfEmail.isUserInteractionEnabled = false
            }else{
                tfEmail.isUserInteractionEnabled = true
            }
        }
        
        tfFirst.TATextfiledPlaceHolderTextColor = TAColor.TAPinTextColor
        tfFirst.TATextfiledPlaceHolderTextFont = TAFontIcon.TAFontMedium
        
        //MARK: Configuration for Password Textfiled placeHolder
        tfSecond.TATextfiledPlaceHolderText = "********"
        tfSecond.TATextfiledPlaceHolderTextColor = TAColor.TAPinTextColor
        tfSecond.TATextfiledPlaceHolderTextFont = TAFontIcon.TAFontMedium
        
      
        //MARK: Configuration for ForgotPassword Button
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Regular")
        btnForgotPassword.TABtnTitleText = "Forgot Password?"
        btnForgotPassword.TABtnTitleTextColor = TAColor.TAForgotButtonTitleColor
        btnForgotPassword.TABtnTitleTextFont = TAFontIcon.TAFontRegular
        btnForgotPassword.TABtnBackgrounColor = .white
        
        
        //MARK: Configuration for Validate Buttun
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        btnValid.TABtnTitleText = "Validate"
        btnValid.TABtnTitleTextColor = TAColor.TAButtonTextColor
        btnValid.TABtnTitleTextFont = TAFontIcon.TAFontMedium
        btnValid.TABtnBackgrounColor = TAColor.TAButtonBackgroundColor
        btnValid.TABtnCornerRadius = 5
        
        
        //MARK: Configuration for ContainerView
        containerView.TAViewCornerRadius = 20
        containerView.TAViewShadowColor = TAColor.TAShadowColor
        containerView.TAViewShadowOpacity = 0.4
        containerView.TAViewShadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.TAViewShadowRadius = 6
        containerView.TAViewHeight = 500
        
        
        //MARK: Assign Values
        authConfigObj.logoImage = imgLogo
        authConfigObj.loginLbl = lblLogin
        authConfigObj.authLbl = lblAuthType
        authConfigObj.passwordLbl = lblPassword
        authConfigObj.enterValidAuthLbl = lblEnterValidEmail
        authConfigObj.enterValidPasswordLBl = lblEnterValidPassword
        authConfigObj.tfView = viewTestfiled
        authConfigObj.firstTextfiled = tfFirst
        authConfigObj.secondTextfiled = tfSecond
        authConfigObj.validBtn = btnValid
        authConfigObj.forgotPasswordBtn = btnForgotPassword
        authConfigObj.emailIcon = emailIcon
        authConfigObj.passwordIcon = passwordIcon
        authConfigObj.eyeIcon = eyeIcon
        
       // authConfigObj.containerViewShow = containerView
        
        return authConfigObj
    }
    
    //MARK: Set Configurations
    public func setThemWithAuthConfiguration(config:AuthenticationConfiguration){
        
        setThemsForHeaderViewImageORLogo(img: imgLogo, config: config.logoImage)
        
        setThemsForLabel(lbl: lblEmailIcon, config: config.emailIcon)
        
        setThemsForLabel(lbl: lblLogin, config: config.loginLbl)
        
        setThemsForLabel(lbl: lblAuthType, config: config.authLbl)
        
        setThemsForLabel(lbl: lblEnterValidAuth, config: config.enterValidAuthLbl)
        
        setThemsForLabel(lbl: lblPassword, config: config.passwordLbl)
        
        setThemsForLabel(lbl: lblEnterValidePassword, config: config.enterValidPasswordLBl)
        
        setThemsForView(view: viewPassword, config: config.tfView)
        
        setThemsForView(view: viewAuthType, config: config.tfView)
        
        setThemsForTextField(textfiled: tfEmail, config: config.firstTextfiled)
        
        setThemsForTextField(textfiled: tfPassword, config: config.secondTextfiled)
        
        setThemsForButton(btn: btnForgotPassword, config: config.forgotPasswordBtn)
        
        setThemsForButton(btn: btnValidate, config: config.validBtn)
        
        setThemsForLabel(lbl: lblPasswordIcon, config: config.passwordIcon)
        
        setThemsForButton(btn: btnEyeIcon, config: config.eyeIcon)
        
        viewContainerAuth.isHidden = false
    }
    
    //MARK: IBAction
    @IBAction func validateBtnAction(_ sender:UIButton){
        
        if authType == .USERNAME_PASSWORD {
            
            let username = ValidationClass.shared.isUsernameValid(username: tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            let password = ValidationClass.shared.isPasswordValid(password: tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            
            if username.1 == false && password.1 == false {
                lblEnterValidAuth.text = username.0
                lblEnterValidePassword.text = password.0
            } else if username.1 == true && password.1 == false{
                lblEnterValidAuth.text = ""
                lblEnterValidePassword.text = password.0
            } else if username.1 == false && password.1 == true{
                lblEnterValidePassword.text = ""
                lblEnterValidAuth.text = username.0
            }else if username.1 == true && password.1 == true{
                lblEnterValidAuth.text = ""
                lblEnterValidePassword.text = ""
                delegate?.validAuthBtnActionDelegate(email: tfEmail.text ?? "", password: tfPassword.text ?? "")
            }
        } else {
            // email and password
            
            let email = ValidationClass.shared.isEmailValid(email: tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            let password = ValidationClass.shared.isPasswordValid(password: tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            
            if email.1 == false && password.1 == false {
                lblEnterValidAuth.text = email.0
                lblEnterValidePassword.text = password.0
            } else if email.1 == true && password.1 == false{
                lblEnterValidAuth.text = ""
                lblEnterValidePassword.text = password.0
            } else if email.1 == false && password.1 == true{
                lblEnterValidePassword.text = ""
                lblEnterValidAuth.text = email.0
            }else if email.1 == true && password.1 == true{
                lblEnterValidAuth.text = ""
                lblEnterValidePassword.text = ""
                delegate?.validAuthBtnActionDelegate(email: tfEmail.text ?? "", password: tfPassword.text ?? "")
            }
        }
    }
    
    //MARK: @IBAction For EyeButton
    @IBAction func eyeBtnAction(){
        
        if tfPassword.isSecureTextEntry {
            setThemsForFont(FontClass: TAFontIcon.self)
            AddFontIconToButton(btn: btnEyeIcon, titles: TAFontIcon.TA_Icon_eye, color: TAColor.TAPasswordEyeIconColor, size: 20)

        }else{
            setThemsForFont(FontClass: TAFontIcon.self)
            AddFontIconToButton(btn: btnEyeIcon, titles: TAFontIcon.TA_Icon_eye_off, color: TAColor.TAPasswordEyeIconColor, size: 20)
        }
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
    }

    @IBAction func forgotPasswordBtnAction(){
        
    }
}

//MARK: UITextFieldDelegate Extension
extension AuthenticationLogIn:UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}


