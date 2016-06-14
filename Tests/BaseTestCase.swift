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
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.urlForResource(fileName, withExtension: withExtension)!
    }
    
    func StringForResource(fileName: String, ofType: String) -> String {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.pathForResource(fileName, ofType: ofType)!
    }
    
}
