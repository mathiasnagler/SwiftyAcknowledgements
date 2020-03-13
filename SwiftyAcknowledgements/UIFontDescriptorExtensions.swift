//
//  UIFontDescriptorExtensions.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 28.10.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import Foundation
import UIKit

internal extension UIFontDescriptor {
    
    /// Returns the point-size of the preffered font for a text style
    /// The user can influence this value by changing the font-size setting
    internal class func preferredFontSize(withTextStyle style: String) -> CGFloat {
        let style = self.preferredFontDescriptor(withTextStyle: UIFont.TextStyle(rawValue: style))
        return style.pointSize
    }

}
