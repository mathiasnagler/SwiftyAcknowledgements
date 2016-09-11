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
    
    func URLForResource(_ fileName: String, withExtension: String) -> URL {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.url(forResource: fileName, withExtension: withExtension)!
    }
    
    func StringForResource(_ fileName: String, ofType: String) -> String {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.path(forResource: fileName, ofType: ofType)!
    }
    
}
