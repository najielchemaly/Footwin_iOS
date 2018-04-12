//
//  Localization.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

//import Foundation
//import UIKit
//
//class Localization: NSObject {
//
//    class func currentLanguage(forDevice: Bool = false) -> String {
//        let userDef = UserDefaults.standard
//        var languageArray: NSArray
//        if forDevice {
//            let language = userDef.object(forKey: DEVICE_LANGUAGE_KEY) as! String
//            let currentLanguageWithoutLocale = language.substring(to: language.index(language.startIndex, offsetBy: 2))
//            return currentLanguageWithoutLocale
//        } else {
//            languageArray = userDef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
//        }
//        let currentLanguage = languageArray.firstObject as! String
//        let currentLanguageWithoutLocale = currentLanguage.substring(to: currentLanguage.index(currentLanguage.startIndex, offsetBy: 2))
//        return currentLanguageWithoutLocale
//    }
//
//    class func setLanguageTo(_ lang: String) {
//        let userDef = UserDefaults.standard
//        userDef.set([lang, currentLanguage()], forKey: APPLE_LANGUAGE_KEY)
//        userDef.synchronize()
//
//        if lang == "en" {
//            if #available(iOS 9.0, *) {
//                UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            } else {
//                // Fallback on earlier versions
//            }
//            UISwitch.appearance().semanticContentAttribute = .forceRightToLeft
//            UIImageView.appearance().semanticContentAttribute = .forceRightToLeft
//            UIPageControl.appearance().semanticContentAttribute = .forceLeftToRight
//        } else if lang == "ar" {
//            if #available(iOS 9.0, *) {
//                UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            } else {
//                // Fallback on earlier versions
//            }
//            UISwitch.appearance().semanticContentAttribute = .forceLeftToRight
//            UIImageView.appearance().semanticContentAttribute = .forceLeftToRight
//            UIPageControl.appearance().semanticContentAttribute = .forceRightToLeft
//        }
//    }
//
//    class func doTheExchange() {
//        exchangeMethods(UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
//        exchangeMethods(Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
//        exchangeMethods(UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews))
//        exchangeMethods(UITextView.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextView.cstmlayoutSubviews))
//        exchangeMethods(UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))
//        exchangeMethods(UIButton.self, originalSelector: #selector(UIButton.layoutSubviews), overrideSelector: #selector(UIButton.cstmlayoutSubviews))
//    }
//
//    // Exchange the implementation of two methods for the same Class
//    class func exchangeMethods(_ cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
//        let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!
//        let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!
//        if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
//            class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//        } else {
//            method_exchangeImplementations(origMethod, overrideMethod);
//        }
//    }
//
//    class func setTextAlignment(textfield: UITextField) {
//        let language = currentLanguage()
//        if language == "en" {
//            textfield.textAlignment = .left
//        } else if language == "ar" {
//            textfield.textAlignment = .right
//        }
//    }
//}
//
//extension Bundle {
//    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
//        if self == Bundle.main {
//            let currentLanguage = Localization.currentLanguage()
//            var bundle = Bundle();
//            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
//                bundle = Bundle(path: _path)!
//            } else {
//                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
//                bundle = Bundle(path: _path)!
//            }
//            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
//        } else {
//            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
//        }
//    }
//}
//
//extension UITextField {
//    @objc public func cstmlayoutSubviews() {
//
//        if self.tag <= 0 {
//            if Localization.currentLanguage() == "ar" && self.textAlignment != .right {
//                self.textAlignment = .right
//            } else if Localization.currentLanguage() == "en" && self.textAlignment != .left {
//                self.textAlignment = .left
//            }
//        }
//
//        self.cstmlayoutSubviews()
//    }
//}
//
//extension UILabel {
//    @objc public func cstmlayoutSubviews() {
//
//        if currentVC == nil || (currentVC.presentedViewController as? UIAlertController) != nil {
//            return
//        }
//
//        if self.tag <= 0 {
//            if Localization.currentLanguage() == "ar" && self.textAlignment != .right {
//                self.textAlignment = .right
//            } else if Localization.currentLanguage() == "en" && self.textAlignment != .left {
//                self.textAlignment = .left
//            }
//        }
//
//        self.cstmlayoutSubviews()
//    }
//}
//
//extension UIButton {
//    @objc public func cstmlayoutSubviews() {
//
//        if self.tag < 0 {
//            if Localization.currentLanguage() == "ar" {
//                self.contentHorizontalAlignment = .right
//            } else if Localization.currentLanguage() == "en" {
//                self.contentHorizontalAlignment = .left
//                self.contentEdgeInsets.left = 10
//            } else {
//                //                return
//            }
//        }
//
//        self.cstmlayoutSubviews()
//    }
//}
//
//extension UITextView {
//    @objc public func cstmlayoutSubviews() {
//
//        if self.tag <= 0 {
//            if Localization.currentLanguage() == "ar" && self.textAlignment != .right {
//                self.textAlignment = .right
//            } else if Localization.currentLanguage() == "en" && self.textAlignment != .left {
//                self.textAlignment = .left
//            }
//        }
//
//        self.cstmlayoutSubviews()
//    }
//
//}
//
//extension UIApplication {
//    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
//        get {
//            var direction = UIUserInterfaceLayoutDirection.rightToLeft
//            if Localization.currentLanguage() == "ar" {
//                direction = .leftToRight
//            }
//            return direction
//        }
//    }
//}
//

