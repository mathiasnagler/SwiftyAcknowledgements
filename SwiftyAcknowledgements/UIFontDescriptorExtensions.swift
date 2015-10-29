//
//  UIFontDescriptorExtensions.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 28.10.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import Foundation

internal extension UIFontDescriptor {
    
    internal class func preferredFontSizeTextStyle(style: String) -> CGFloat {
        let style = self.preferredFontDescriptorWithTextStyle(style)
        return style.pointSize
    }

}
