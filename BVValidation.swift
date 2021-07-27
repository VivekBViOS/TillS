//
//  BVValidation.swift
//
//
//  Created by VB on 31/12/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

enum BVValidationType {
    case blank
    case email
    case name
    case password
    case number
    case phoneNumber
    case integer
    case alphaNoSpace
    case alphaWithSpace
    case alphaNumericNospace
    case alphaNumericWithspace
    case regExp
}

enum BVValidationResult {
    case valid
    case invalid
    case blank
    case notAlpha
    case notNumber
    case notInteger
    case lessLength
    case moreLength
    case containSpace
}

class BVValidation: NSObject {
    
    //MARK:
    class func isBlank(_ string:String?) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard string!.trimmedLength > 0 else {
            return .blank
        }
        
        return .valid
    }
    
    class func validateEmail(_ email:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = email else {
            return .blank
        }
        
        guard isRequire == true && email!.length > 0 else {
            return .blank
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return validateString(email!, againstRegExp: emailRegex)
    }
    
    class func validatePassword(_ password:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = password else {
            return .blank
        }
        
        guard isRequire == true && password!.length > 0 else {
            return .blank
        }
        
        guard password == password!.trimmed else {
            return .containSpace
        }
        
        let result = self.validateLength(password, min: 8, max: 16, isRequire: true)
        
        guard result == .valid else {
            return result
        }
        
        return .valid
        //        let passwordRegex = "^(?=.{6,32}$)(?=.*[A-Z]).*$"
        //
        //        return validateString(password!, againstRegExp: passwordRegex)
    }
    
    class func validateName(_ name:String?, isRequire:Bool) -> BVValidationResult {
        
        let result = validateLength(name!.trimmed, min: 2, max: 60, isRequire: isRequire)
        
        guard result == .valid else {
            return result
        }
        
        return validateString(name!.trimmed, againstRegExp: "(^[A-Za-z0-9 _.'-]{2,60})")
    }
    
    //MARK:
    class func validateNumber(_ number:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = number else {
            return .blank
        }
        
        guard isRequire == true && number!.length > 0 else {
            return .blank
        }
        
        let formatter = NumberFormatter()
        let isNumber = formatter.number(from: number!)
        
        guard let _ = isNumber else {
            return .invalid
        }
        
        return .valid
    }
    
    //MARK:
    class func validatePhoneNumber(_ number:String?, isRequire:Bool) -> BVValidationResult {
        
        let result = validateLength(number!.trimmed, min: 7, max: 12, isRequire: isRequire)
        
        guard result == .valid else {
            return result
        }
        
        return validateString(number!.trimmed, againstRegExp: "^\\d+$")
    }
    
    class func validateInteger(_ integer:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = integer else {
            return .blank
        }
        
        guard isRequire == true && integer!.length > 0 else {
            return .blank
        }
        
        guard let _ = Int(integer!) else {
            return .invalid
        }
        
        return .valid
    }
    
    //MARK:
    class func validateAlphaNoSpace(_ string:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.trimmedLength > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z]+")
    }
    
    class func validateAlphaWithSpace(_ string:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z ]+")
    }
    
    class func validateAlphaNumericNoSpace(_ string:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.trimmedLength > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z0-9]+")
    }
    
    class func validateAlphaNumericWithSpace(_ string:String?, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z0-9 ]+")
    }
    
    //MARK:
    class func validateLength(_ string:String?, min:Int, max:Int, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        guard string!.length >= min else {
            return .lessLength
        }
        
        guard string!.length <= max else {
            return .moreLength
        }
        
        return .valid
    }
    
    class func validateMinLength(_ string:String?, min:Int, isRequire:Bool) -> BVValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        guard string!.length >= min else {
            return .lessLength
        }
        
        return .valid
    }
    
    //MARK:
    class func validateString(_ string:String, againstRegExp regExp:String) -> BVValidationResult {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", regExp)
        
        if emailTest.evaluate(with: string) {
            return .valid
        } else {
            return .invalid
        }
    }
    
    //MARK:
    class func validateDate(_ date:Date?, isAfterDate pastDate:Date?) -> BVValidationResult {
        
        guard date!.compare(pastDate!) == .orderedDescending else {
            return .invalid
        }
        
        return .valid
    }
    
    class func validateDate(_ date:Date?, isBeforeDate futureDate:Date?) -> BVValidationResult {
        
        guard date!.compare(futureDate!) == .orderedAscending else {
            return .invalid
        }
        
        return .valid
    }
    
    class func validateDate(_ date:Date?, isBetweenDate firstDate:Date, andDate secondDate:Date) -> BVValidationResult {
        
        guard date!.compare(firstDate) == .orderedDescending else {
            return .invalid
        }
        
        guard date!.compare(secondDate) == .orderedAscending else {
            return .invalid
        }
        
        return .valid
    }
}

extension UITextField {
    
    func validate(BVValidationType type:BVValidationType, getFocus focusOnError:Bool = false, alertMessage message:String = "") -> BVValidationResult {
        
        var result : BVValidationResult?
        
        switch type {
        case .blank:
            result = BVValidation.isBlank(text)
        case .email:
            result = BVValidation.validateEmail(text, isRequire: true)
        case .password:
            result = BVValidation.validatePassword(text, isRequire: true)
        case .name:
            result = BVValidation.validateName(text, isRequire: true)
        case .number:
            result = BVValidation.validateNumber(text, isRequire: true)
        case .phoneNumber:
            result = BVValidation.validatePhoneNumber(text, isRequire: true)
        case .integer:
            result = BVValidation.validateInteger(text, isRequire: true)
        case .alphaNoSpace:
            result = BVValidation.validateAlphaNoSpace(text, isRequire: true)
        case .alphaWithSpace:
            result = BVValidation.validateAlphaWithSpace(text, isRequire: true)
        case .alphaNumericNospace:
            result = BVValidation.validateAlphaNumericNoSpace(text, isRequire: true)
        case .alphaNumericWithspace:
            result = BVValidation.validateAlphaNumericWithSpace(text, isRequire: true)
        default:
            result = BVValidation.isBlank(text)
        }
        
        if focusOnError == true {
            if result != .valid {
                becomeFirstResponder()
            }
        }
        
        if message.trimmedLength > 0 {
            //show alert here
        }
        
        return result!
    }
    
    func validateWithRegExp(expression regExp:String, showRedRect errorRect:Bool = false, getFocus focusOnError:Bool = false, alertMessage message:String = "") -> BVValidationResult {
        
        let result = BVValidation.validateString(text!, againstRegExp: regExp)
        
        if  errorRect == true {
            //    if(result != BVBVValidationResultValid)
            //    {
            //        (self.layer).borderWidth = 2;
            //        (self.layer).borderColor = [UIColor mainRedColor].CGColor;
            //        [self setClipsToBounds:YES];
            //    }
            //    else
            //    {
            //        (self.layer).borderWidth = 0;
            //        (self.layer).borderColor = [UIColor clearColor].CGColor;
            //        [self setClipsToBounds:NO];
            //    }
        }
        
        if focusOnError == true {
            becomeFirstResponder()
        }
        
        if message.trimmedLength > 0 {
            //show alert here
        }
        
        return result
    }
    
}


