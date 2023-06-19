//
//  MobilePinView.swift
//  Reusable
//
//  Created by Akash Belekar on 27/04/23.
//


import UIKit
import Foundation

//MARK: Protocol MobileNumberDelegate
public protocol MobileNumberDelegate{
    func validMobileBtnActionDelegate(mobileNumber:String)
}
public class Mobile_Number:UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak public var viewContainerMobile:UIView!
    @IBOutlet weak public var imgLogo:UIImageView!
    @IBOutlet weak public var lblLogin:UILabel!
    @IBOutlet weak public var lblMobile:UILabel!
    @IBOutlet weak public var lblCountryCode:UILabel!
    @IBOutlet weak public var lblIconCountryCode:UILabel!
    @IBOutlet weak public var viewTfMobileNumber:UIView!
    @IBOutlet weak public var viewCountryCode:UIView!
    @IBOutlet weak public var tfMobileNumber:UITextField!
    @IBOutlet weak public var lblEnterValidMobNum:UILabel!
    @IBOutlet weak public var btnValidate:UIButton!
    @IBOutlet weak public var viewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak public var lblEnterValidMobileHeight:NSLayoutConstraint!
    @IBOutlet weak public var btnCountryCode:UIButton!
    
    //MARK: Variables
    let nibName = "Mobile_Number"
    public var delegate:MobileNumberDelegate?
    public var mobileConfig = AuthenticationConfiguration()
    public weak var controller: UIViewController?
    
    private let pickerViewtag = 2345
    
    //MARK: System methods
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    //MARK: SetDefaultThems
    public func setMobileDefaultThemes(){
        let mobileConfig = themsConfiguration()
        self.setThemeWithMobileConfiguration(config: mobileConfig)
    }
    
    //MARK: Configure DefaultThems
    func themsConfiguration() -> AuthenticationConfiguration{
        let config = AuthenticationConfiguration()
        let containerView = TAUIView()
        let imgLogo = TAImage()
        let lblLogin = TALable()
        let lblMobile = TALable()
        let lblCountryCode = TALable()
        let lblCountryCodeIcon = TALable()
        let tfView = TAUIView()
        let viewCountryCode = TAUIView()
        let btnCuntryCode = TAButton()
        let textField = TATextFiled()
        let lblEnterValidMobile = TALable()
        let btnValide = TAButton()
        
        //MARK: Configuration for ContainerView
        containerView.TAViewCornerRadius = 10
        containerView.TAViewShadowColor = TAColor.TAShadowColor
        containerView.TAViewShadowOpacity = 0.4
        containerView.TAViewShadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.TAViewShadowRadius = 6
        containerView.TAViewHeight = 350
        
        //MARK: Configuration for Image Logo
        if let image = UIImage(named: "logo",in: Bundle(for:TAAssetsImage.self ),compatibleWith: nil){
            imgLogo.TAImageLogo = image
        }
        
        //MARK: Configuration for Login Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Bold")
        lblLogin.TAText = "Login"
        lblLogin.TATextColor = TAColor.TATextLblColor
        lblLogin.TATextAlignment = .left
        lblLogin.TATextFont = TAFontIcon.TAFontBold
        
        //MARK: Configuration for Mobile Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        lblMobile.TAText = "Mobile"
        lblMobile.TATextColor = TAColor.TATextLblColor
        lblMobile.TATextAlignment = .left
        lblMobile.TATextFont = TAFontIcon.TAFontMedium
        
        //MARK: Configuration for Mobile TextFiled View
        tfView.TAViewCornerRadius = 5
        tfView.TAViewborderWidth = 1
        tfView.TAViewBorderColor = TAColor.TAShadowColor
        
        //MARK: Configuration for Country Code Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        lblCountryCode.TAText = "+1"
        lblCountryCode.TATextColor = TAColor.TATextLblColor
        lblCountryCode.TATextFont = TAFontIcon.TAFontMedium
        lblCountryCode.TATextAlignment = .left
        lblCountryCode.TATextNumberOfLines = 0
        
        //MARK: Configuration for Country Code Icon Label
        lblCountryCodeIcon.TAText = TAFontIcon.TA_Icon_down_arrow
        lblCountryCodeIcon.TATextColor = TAFontIcon.TATextColor
        lblCountryCodeIcon.TATextFont = UIFont(name: "authentication_font_file", size: 20)!
        
        //MARK: Configuration for Email Textfiled PlaceHolder
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        textField.TATextfiledPlaceHolderText = "1234 56 7890"
        textField.TATextfiledPlaceHolderTextColor = TAColor.TAPinTextColor
        textField.TATextfiledPlaceHolderTextFont = TAFontIcon.TAFontMedium
        
        //MARK: Configuration for CountryCode View
        viewCountryCode.TAViewBorderColor = TAColor.TAPlaceholderText_borderColor
        viewCountryCode.TAViewborderWidth = 1
        viewCountryCode.TAViewCornerRadius = 5
        
        
        //MARK: Configuration for Enter Valid Mobile Label
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Regular")
        lblEnterValidMobile.TAText = ""
        lblEnterValidMobile.TATextFont = TAFontIcon.TAFontRegularErrMsg
        lblEnterValidMobile.TATextColor = TAColor.TAValidAuthColor
        
        //MARK: Configuration for valide Button
        setThemsForFontLabel(FontClass: TAFontIcon.self, Font: "Poppins-Medium")
        btnValide.TABtnTitleText = "Validate"
        btnValide.TABtnTitleTextColor = TAColor.TAButtonTextColor
        btnValide.TABtnBackgrounColor = TAColor.TAButtonBackgroundColor
        btnValide.TABtnTitleTextFont = TAFontIcon.TAFontMedium
        btnValide.TABtnCornerRadius = 5
        btnValide.TABtnMasksToBounds = true
        
        
        //MARK: Assign Value
        config.containerViewShow = containerView
        config.logoImage = imgLogo
        config.loginLbl = lblLogin
        config.mobileLbl = lblMobile
        config.countryCountryLbl = lblCountryCode
        config.countryCodeIcon = lblCountryCodeIcon
        config.countryCodeView = viewCountryCode
        config.tfView = tfView
        config.countryCodeBtn = btnCuntryCode
        config.firstTextfiled = textField
        config.enterValidMobileNumber = lblEnterValidMobile
        config.validBtn = btnValide
        
        return config
    }
    
    //MARK: Set Configurations
    public func setThemeWithMobileConfiguration(config:AuthenticationConfiguration){
        
        setThemsForHeaderViewImageORLogo(img: imgLogo, config: config.logoImage)
        
        setThemsForLabel(lbl: lblLogin, config: config.loginLbl)
        
        setThemsForLabel(lbl: lblMobile, config: config.mobileLbl)
        
        setThemsForView(view: viewTfMobileNumber, config: config.countryCodeView)
        
        setThemsForView(view: viewCountryCode, config: config.countryCodeView)
        
        setThemsForLabel(lbl: lblCountryCode, config: config.countryCountryLbl)
        
        setThemsForLabel(lbl: lblIconCountryCode, config: config.countryCodeIcon)
        
        setThemsForTextField(textfiled: tfMobileNumber, config: config.firstTextfiled)
        
        setThemsForLabel(lbl:lblEnterValidMobNum , config: config.enterValidMobileNumber)
        
        setThemsForButton(btn: btnValidate, config: config.validBtn)
        
    }
    
    //MARK: Custom methods
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        tfMobileNumber.delegate = self
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundel = Bundle(for: Mobile_Number.self)
        let nib = bundel.loadNibNamed(nibName, owner: self)?.first as? UIView
        return nib
    }
    
    //MARK: setupToolBar
    func setupToolBar(){
        let barBtn = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnTapped(_ :)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barBtn.items = [flexSpace,flexSpace,doneBtn]
        barBtn.sizeToFit()
        tfMobileNumber.inputAccessoryView = barBtn
    }
    
    @objc func doneBtnTapped(_ tap:UITapGestureRecognizer){
        viewContainerMobile.endEditing(true)
    }
    
    private func removePickerView() {
        
        if let tagView = self.viewWithTag(self.pickerViewtag){
            tagView.removeFromSuperview()
        }
    }
    
    
    func ShowContryCodeList() {
        
        if #available(iOS 14.0, *) {
            var tempArr = [UIAction]()
            for code in countryArray {
                
                let action = UIAction(title: code, image:nil, attributes: .Element(), handler: { (_) in
                    self.lblCountryCode.text = code
                })
                tempArr.append(action)
            }
            
            var demoMenu: UIMenu {
                return UIMenu(title: "Select country code", image: nil, identifier: nil, options: [], children: tempArr)
            }
           
            btnCountryCode.showsMenuAsPrimaryAction = true
            btnCountryCode.menu = demoMenu
            
        } else {
            
            let pickerView = DataPickerView.init()
            pickerView.delegate = self
            pickerView.frame = self.viewContainerMobile.frame
            pickerView.tag = pickerViewtag
            pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.40)
            self.addSubview(pickerView)
            pickerView.scrollToValue(value: self.lblCountryCode.text ?? "")
        }

    }
    
    
    //MARK: IBAction
    @IBAction func validBtnAction(_ sender:UIButton) {
        let phoneNumber = self.tfMobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let validatePhone = ValidationClass.shared.isPhoneValid(phone: phoneNumber)
        
        if validatePhone.1 == false{
            lblEnterValidMobNum.text = validatePhone.0
        }else{
            lblEnterValidMobNum.text = ""
            delegate?.validMobileBtnActionDelegate(mobileNumber: (self.lblCountryCode.text ?? "") + (tfMobileNumber.text ?? ""))
        }
    }
    
    @IBAction func countryCodeBtnAction(_ sender:UIButton){
        ShowContryCodeList()
    }
}

//MARK: UITextFieldDelegate Extension
extension Mobile_Number:UITextFieldDelegate{
    
    //MARK: Keyboard Open
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: valid till 10 Digit
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfMobileNumber{
            
            _ = tfMobileNumber.text!.count + string.count - range.length
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            
            _ = newString.filter { $0.isNumber }
            let allowedCharacterSet = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let isOnlyDigits = allowedCharacterSet.isSuperset(of: characterSet)
            let isTenDigits = newString.count <= 10
            
            if newString.count == 10  {
                if let textFieldText = textField.text {
                    //  let mobileNumberText = formatMobileNumber(number: newString)
                    _ = textFieldText.replacingCharacters(in: Range(range, in: textFieldText)!, with: newString)
                    textField.text = newString
                    //textField.text = mobileNumberText
                }
                return false
            }
            return isOnlyDigits && isTenDigits
        }
        return true
    }
}

extension Mobile_Number : DataPickerDelegate {
    public func DataPickerWithValue(value: String) {
        lblCountryCode.text = value
        self.removePickerView()
    }
    
    public func DataPickerDismiss() {
        self.removePickerView()
    }
    
    
}
