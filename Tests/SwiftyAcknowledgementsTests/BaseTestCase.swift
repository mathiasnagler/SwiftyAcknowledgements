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
        #if XCODE
        let bundle = Bundle(for: BaseTestCase.self)
        #else
        let bundle = Bundle.module
        #endif
        return bundle.url(forResource: fileName, withExtension: withExtension, subdirectory: "TestResources")!
    }
    
    func StringForResource(_ fileName: String, ofType: String) -> String {
		#if XCODE
        let bundle = Bundle(for: BaseTestCase.self)
		print("Xcdoe")
        #else
        let bundle = Bundle.module
        #endif
        return bundle.path(forResource: fileName, ofType: ofType, inDirectory: "TestResources")!
    }
    
}
