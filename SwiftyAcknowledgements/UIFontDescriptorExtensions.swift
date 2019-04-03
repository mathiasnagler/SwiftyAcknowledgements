//
//  UIFontDescriptorExtensions.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 28.10.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import Foundation

internal extension UIFontDescriptor {
    
    /// Returns the point-size of the preffered font for a text style
    /// The user can influence this value by changing the font-size setting
    class func preferredFontSize(for style: UIFont.TextStyle) -> CGFloat {
        let style = self.preferredFontDescriptor(withTextStyle: style)
        return style.pointSize
    }

}
