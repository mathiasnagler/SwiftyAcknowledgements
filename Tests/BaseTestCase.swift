//
//  BaseTestClass.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 29.10.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import XCTest
import UIKit
import SwiftyAcknowledgements

class BaseTestCase: XCTestCase {
    
    func URLForResource(fileName: String, withExtension: String) -> NSURL {
        let bundle = NSBundle(forClass: BaseTestCase.self)
        return bundle.URLForResource(fileName, withExtension: withExtension)!
    }
    
    func StringForResource(fileName: String, ofType: String) -> String {
        let bundle = NSBundle(forClass: BaseTestCase.self)
        return bundle.pathForResource(fileName, ofType: ofType)!
    }
    
}
