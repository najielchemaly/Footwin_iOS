//
//  Extensions.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation
import FSPagerView
import UIKit

extension UIColor {
    public convenience init?(hexString: String, alpha: CGFloat = 1) {
        assert(hexString[hexString.startIndex] == "#", "Expected hex string of format #RRGGBB")
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    a = alpha
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIView {
    
    func animate(withDuration duration: TimeInterval = 1.0, alpha: CGFloat = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        })
    }
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func loadAndSetupXib(fromNibNamed nibName: String) {
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func customizeView(color: UIColor, withRadius: Bool = true) {
        self.backgroundColor = color
        
        if withRadius {
            self.layer.cornerRadius = 10.0
        }
    }
    
    func customizeBorder(color: UIColor, border: CGFloat = 2.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = border
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat, alpha: CGFloat = 1) {
        let border = CALayer()
        border.backgroundColor = color.withAlphaComponent(alpha).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func isEnabled(enable: Bool) {
        self.isUserInteractionEnabled = enable
        self.alpha = enable ? 1 : 0.8
    }
    
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
    func count() -> Int {
        if let text = self.text {
            return text.count.advanced(by: 0)
        }
        
        return 0
    }
    
    func isValidEmail() -> Bool {
        if let text = self.text {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return email.evaluate(with: text)
        }
        
        return false
    }
    
    func validate(validationType: ValidationType = .Required, fieldType: FieldType, password: String = "") -> String {
        switch validationType {
        case .MaxLength:
            if fieldType == .Fullname && self.count() > 50 {
                return fieldType.title + " cannot be more than 50 characters"
            } else if fieldType == .Username && self.count() > 20 {
                return fieldType.title + " cannot be more than 20 characters"
            } else if fieldType == .Phone && self.count() > 15 {
                return fieldType.title + " cannot be more than 15 characters"
            } else if fieldType == .Password && self.count() > 16 {
                return fieldType.title + " cannot be more than 16 characters"
            }
        case .MinLength:
            if fieldType == .Fullname && self.count() < 2 {
                return fieldType.title + " must be at least 2 characters"
            } else if fieldType == .Username && self.count() < 4 {
                return fieldType.title + " must be at least 4 characters"
            } else if fieldType == .Phone && self.count() < 8 {
                return fieldType.title + " must be at least 8 characters"
            } else if fieldType == .Password && self.count() < 6 {
                return fieldType.title + " must be at least 6 characters"
            }
        case .Regex:
            if !isValidEmail() {
                return "You must enter a valid email"
            }
        case .Required:
            if self.isEmpty() {
                return fieldType.title + " cannot be empty"
            }
        case .Passwords:
            if self.text != password {
                return "Password do not match"
            }
        }
        
        return ""
    }
    
}

extension UITextView {
    
    func isEmpty() -> Bool {
        return (self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
}

extension UIDatePicker {
    
    func setMaxDate() {
        self.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
    }
    
}

extension UIViewController {
    
    enum NavigationType : String {
        case push = "PUSH"
        case present = "PRESENT"
        case popup = "POPUP"
        case fromBottom = "FROM BOTTOM"
    }
    
    func redirectToVC(storyboard: UIStoryboard? = nil, storyboardId: String, type: NavigationType, newsType: NewsType = NewsType.None, animated: Bool = true, title: String? = nil, backTitle: String? = "BACK", delegate: UIPopoverPresentationControllerDelegate? = nil) {
        let storyboard = storyboard ?? self.storyboard
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: storyboardId) {
            switch type {
            case .push:
                destinationVC.navigationItem.backBarButtonItem?.title = backTitle
                destinationVC.navigationItem.title = title
                
                currentVC.navigationController?.pushViewController(destinationVC, animated: animated)
                break
            case .present:
                self.present(destinationVC, animated: animated, completion: nil)
                break
            case .popup:
                destinationVC.modalPresentationStyle = .popover
                let popover = destinationVC.popoverPresentationController
                popover?.permittedArrowDirections = .init(rawValue: 0)
                popover?.sourceRect = view.bounds
                popover?.sourceView = view
                popover?.delegate = delegate
                
                self.present(destinationVC, animated: true, completion: nil)
                break
            case .fromBottom:
                let transition = CATransition()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                currentVC.navigationController?.view.layer.add(transition, forKey: kCATransition)
                currentVC.navigationController?.pushViewController(destinationVC, animated: false)
                break
            }
        }
    }
    
    func showAlert(title: String = NSLocalizedString("Alert", comment: ""), message: String, style: UIAlertControllerStyle, popVC: Bool = false, dismissVC: Bool = false) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { action in
            if popVC {
                self.popVC()
            } else if dismissVC {
                self.dismissVC()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func popVC(toRoot: Bool = false, fromTop: Bool = false) {
        if toRoot {
            self.navigationController?.popToRootViewController(animated: true)
        } else if fromTop {
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            navigationController?.view.layer.add(transition, forKey:kCATransition)
            self.navigationController?.popViewController(animated: false)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIButton {
    
    func customizeLayout(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    func setAttributedText(firstText: String, secondText: String, color: UIColor) {
        let firstAttrs = [NSAttributedStringKey.foregroundColor : color]
        let attributedString = NSMutableAttributedString(string: firstText, attributes: firstAttrs)
        let secondAttrs = [NSAttributedStringKey.font : Fonts.textFont_Bold, NSAttributedStringKey.foregroundColor : color]
        let attrString = NSMutableAttributedString(string: secondText, attributes:secondAttrs)
        attributedString.append(attrString)
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setSelected(value: Bool) {
        if value {
            self.backgroundColor = Colors.appBlue
            self.setTitleColor(Colors.lightText, for: .normal)
        } else {
            self.backgroundColor = Colors.lightText
            self.setTitleColor(Colors.darkText, for: .normal)
        }
    }
    
    func isSelected() -> Bool {
        if self.backgroundColor == Colors.appBlue {
            return true
        } else {
            return false
        }
    }
    
    func count() -> Int {
        if let text = self.titleLabel?.text {
            return text.count.advanced(by: 0)
        }
        
        return 0
    }
    
    func isEmpty() -> Bool {
        if let text = self.titleLabel?.text {
            return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        }
        
        return true
    }
    
    func validate(fieldType: FieldType) -> String {
        if self.isEmpty() {
            return fieldType.title + " cannot be empty"
        }
        
        return ""
    }
    
}

extension UIImageView {
    
    func customizeTint(color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}

//extension UIApplication {
//
//    var statusBarView: UIView? {
//        return value(forKey: "statusBar") as? UIView
//    }
//
//}

extension String {
    
    init?(dictionary: NSDictionary) {
        if dictionary["images"] != nil {
            self = dictionary["images"] as! String
        } else {
            self = ""
        }
    }
    
    public static func modelsFromDictionaryArray(array:NSArray) -> [String] {
        var models:[String] = []
        for item in array {
            if let someItem = item as? String {
                models.append(someItem)
            } else {
                models.append(String(dictionary: item as! NSDictionary)!)
            }
        }
        return models
    }
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    
    func safeAddingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String? {
        let allowedCharacters = CharacterSet(bitmapRepresentation: allowedCharacters.bitmapRepresentation)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension FSPageControl {
    
    func hidesForSinglePage(hide: Bool) {
        if hide && self.numberOfPages == 1 {
            self.isHidden = true
        }
    }
    
}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
}

extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getMonthFrom(number: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.monthSymbols[number-1]
        return strMonth
    }
    
}

protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.5) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Bluring {}

extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}
