//
//  UIButton+Extension.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/5/20.
//

import UIKit

private var handleKey: UInt8 = 1
extension UIButton {
    @IBInspectable var localizableTextKey: String? {
        get {
            return objc_getAssociatedObject(self, &handleKey) as? String ?? nil
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &handleKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                setTitle(newValue.localized(), for: .normal)
            }
        }
    }
}
