//
//  String+Localizable.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/4/20.
//

import UIKit

extension String {
    public func localized(manager: CovidContentManager = CovidContentManager.shared,
                          bundle: Bundle? = Bundle.main) -> String {
        return manager.value(for: self, in: bundle)
    }
}

public class CovidContentManager {
    public static var shared = CovidContentManager()

    public func value(for key: String, in bundle: Bundle? = nil) -> String {
        let notFoundValue = "**\(key)**"
        var result: String = notFoundValue

        if result == notFoundValue {
            result = Bundle.main.localizedString(forKey: key,
                                                 value: notFoundValue,
                                                 table: "Localizable")
        }

        let stringPlaceholderPattern = "\\%(?:\\d+\\$s)"
        return result.replacingOccurrences(of: stringPlaceholderPattern,
                                           with: "%@",
                                           options: .regularExpression)
    }
}

private var handleKey: UInt8 = 0
extension UILabel {
    @IBInspectable var localizableTextKey: String? {
        get {
            return objc_getAssociatedObject(self, &handleKey) as? String ?? nil
        }
        set {
            if let newValue = newValue {
                text = newValue.localized()
                sizeToFit()
                objc_setAssociatedObject(self, &handleKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
}
