//
//  AcknowledgementsTests.swift
//  SwiftyAcknowledgementsTests
//
//  Created by Mathias Nagler on 29.10.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import XCTest
import SwiftyAcknowledgements

class AcknowledgementsTests: BaseTestCase {
    
    func testAcknowledgementInitialization() {
        let title = "Title"
        let text = "text"
        let acknowledgement = Acknowledgement(title: title, text: text)
        XCTAssertEqual(acknowledgement.title, title, "The acknowledgements title was incorrect.")
        XCTAssertEqual(acknowledgement.text, text, "The acknowledgements text was incorrect.")
    }
    
    func testLoadAcknowledgementsFromPlist() {
        let plist = StringForResource("Acknowledgements", ofType: "plist")
        let acknowledgements = Acknowledgement.acknowledgementsFromPlistAtPath(plist)
        XCTAssert(acknowledgements.count > 0, "No acknowledgements loaded. Is the plist empty?")
    }
    
}
