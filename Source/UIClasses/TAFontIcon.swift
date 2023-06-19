//
//  TAFont.swift
//  TAAuth
//
//  Created by Akash Belekar on 07/06/23.
//

import Foundation

//MARK: TAFontIcon Class
public class TAFontIcon {
    
    // MARK: Font Icons
    static public let TA_Icon_check = "\u{e900}"
    static public let TA_Icon_down_arrow = "\u{e901}"
    static public let TA_Icon_eye_off = "\u{e905}"
    static public let TA_Icon_eye = "\u{e906}"
    static public let TA_Icon_lock = "\u{e907}"
    static public let TA_Icon_mail = "\u{e908}"
    static public let TA_Icon_user = "\u{e90B}"
    static public let TATextColor = TAColor.TAIconColor
    static public let TAEyeIconColor = UIColor(red: 183/255, green: 187/255, blue: 191/255, alpha: 1)
    static public let TAFontBold = UIFont(name: "Poppins-Bold", size: 28)!
    static public let TAFontMedium = UIFont(name: "Poppins-Medium", size: 14)!
    static public let TAFontRegular = UIFont(name: "Poppins-Regular", size: 14)!
    static public let TAFontRegularErrMsg = UIFont(name: "Poppins-Regular", size: 13)!
}
