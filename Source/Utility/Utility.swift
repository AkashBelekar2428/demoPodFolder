//
//  Utility.swift
//  Authentications
//
//  Created by Akash Belekar on 02/05/23.

import Foundation

//MARK: Image Logo Configuration
public func setThemsForHeaderViewImageORLogo(img: UIImageView, config: TAImage){
    img.image = config.TAImageLogo
}

//MARK: View Configuration
public func setThemsForView(view:UIView, config:TAUIView){
    view.layer.cornerRadius = CGFloat(config.TAViewCornerRadius)
    view.layer.borderColor = config.TAViewBorderColor.cgColor
    view.layer.borderWidth = CGFloat(config.TAViewborderWidth)
}

//MARK: Label Configuration
public func setThemsForLabel(lbl:UILabel, config:TALable){
    lbl.text = config.TAText
    lbl.textColor = config.TATextColor
    lbl.font = config.TATextFont
    lbl.numberOfLines = config.TATextNumberOfLines
    lbl.textAlignment = config.TATextAlignment
    //lbl.lineBreakMode = config.TATextLineBreakMode
    
}

//MARK: TextField Configuration
public func setThemsForTextField(textfiled: UITextField, config:TATextFiled){
    textfiled.text = config.TATfText
    textfiled.placeholder = config.TATextfiledPlaceHolderText
    textfiled.textColor = config.TATextfiledPlaceHolderTextColor
    textfiled.font = config.TATextfiledPlaceHolderTextFont
}

//MARK:  Button Configuration
public func setThemsForButton(btn:UIButton, config:TAButton){
    btn.setTitle(config.TABtnTitleText, for: .normal)
    btn.setTitleColor(config.TABtnTitleTextColor, for: .normal)
    btn.titleLabel?.font = config.TABtnTitleTextFont
    btn.backgroundColor = config.TABtnBackgrounColor
    btn.layer.cornerRadius = CGFloat(config.TABtnCornerRadius)
    btn.layer.masksToBounds = config.TABtnMasksToBounds
}

//MARK: Access Label Font Configuration
public func setThemsForFont(FontClass:AnyClass){
    if let fontURL = Bundle(for: FontClass).url(forResource: "authentication_font_file", withExtension: "ttf"),
       let fontData = try? Data(contentsOf: fontURL) as CFData,
       let provider = CGDataProvider(data: fontData),
       let font = CGFont(provider) {
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let fontError = error?.takeRetainedValue()
            print("Failed to register font - \(fontError?.localizedDescription ?? "")")
        }
    }
}

//MARK: Button Font Icon Configuration
func AddFontIconToButton(btn : UIButton , titles : String , color:UIColor , size : CGFloat){
    btn.titleLabel?.font = UIFont(name: "authentication_font_file", size: size)
    btn.setTitleColor(color, for: .normal)
    btn.setTitle(titles, for: .normal)
}

//MARK:  Label Font Icon Configuration
func AddFontIconToLabel(lbl : UILabel , titles : String , color:UIColor , size : CGFloat){
    lbl.text = titles
    lbl.textColor = color
    lbl.font = UIFont(name: "authentication_font_file", size: size)
}

public func setThemsForFontLabel(FontClass:AnyClass,Font:String){
    if let fontURL = Bundle(for: FontClass).url(forResource: Font, withExtension: "ttf"),
       let fontData = try? Data(contentsOf: fontURL) as CFData,
       let provider = CGDataProvider(data: fontData),
       let font = CGFont(provider) {
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let fontError = error?.takeRetainedValue()
            print("Failed to register font - \(fontError?.localizedDescription ?? "")")
        }
    }
}

//MARK: Masking
func getMaskedEmail(email: String) -> String {
    var maskedEmail = ""
    let splitString = email.split(separator: "@")
    
    if !splitString.isEmpty && !splitString[0].isEmpty {
        let username = splitString[0]
        
        for (index, character) in username.enumerated() {
            if index < 2 {
                maskedEmail.append(character)
            } else {
                maskedEmail.append("*")
            }
        }
    }
    
    maskedEmail.append("@")
    
    var cont = false
    
    if splitString.count > 1 && !splitString[1].isEmpty {
        let domain = splitString[1]
        
        for (index, character) in domain.enumerated() {
            if cont {
                maskedEmail.append(character)
            } else if index == 0 {
                maskedEmail.append(character)
            } else if character == "." {
                maskedEmail.append(character)
                cont = true
            } else {
                maskedEmail.append("*")
            }
        }
    }
    
    return maskedEmail
}

func maskLastFourDigits(mobileNumber: String) -> String {
    var mappedMobile = ""
    mobileNumber.enumerated().forEach { (index, char) in
          if index > 1 {
              if index < 8 {
                  mappedMobile.append("*")
              } else {
                  mappedMobile.append(char)
              }
          }
      }
      return mappedMobile
}

func formatMobileNumber(number: String) -> String {
    let cleanedNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var formattedNumber: String

    if cleanedNumber.count >= 3 {
        let firstPart = cleanedNumber.prefix(3)
        let secondPart = cleanedNumber.dropFirst(3).prefix(3)
        let thirdPart = cleanedNumber.dropFirst(6).prefix(4)
        formattedNumber = "\(firstPart)-\(secondPart)-\(thirdPart)"
    } else {
        formattedNumber = cleanedNumber
    }

    return formattedNumber
}
