//
//  AcknowledgementsTableViewControllerTests.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 29.10.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import XCTest
import SwiftyAcknowledgements

class AcknowledgementsTableViewControllerTests: BaseTestCase {
    
    var viewController: AcknowledgementsTableViewController!
    let a = Acknowledgement(title: "a", text: "a")
    let b = Acknowledgement(title: "b", text: "b")
    let c = Acknowledgement(title: "c", text: "c")
    let d = Acknowledgement(title: "d", text: "d")
    
    override func setUp() {
        super.setUp()
    
        viewController = AcknowledgementsTableViewController()
        viewController.acknowledgements = [a, d, c, b]
    }
    
    override func tearDown() {
        viewController = nil
        
        super.tearDown()
    }
    
    func testAddingCustomAcknowledgement() {
        let countBefore = viewController.acknowledgements.count
        let customAcknowledgement = Acknowledgement(title: "title", text: "text")
        viewController.acknowledgements.append(customAcknowledgement)
        let countAfter = viewController.acknowledgements.count
        XCTAssertNotEqual(countBefore, countAfter, "The count of acknowledgements was invalid after adding a custom acknowledgement.")
        XCTAssert(viewController.acknowledgements.contains(customAcknowledgement), "The added acknowledgement was not contained in the array of acknowledgements.")
    }
    
    func testDefaultSorting() {
        XCTAssert(viewController.acknowledgements == [a, b, c, d], "Default sort did not produce an alphabetically sorted list.")
    }
    
    func testCustomStorting() {
        viewController.sortingClosure = { (left: Acknowledgement, right: Acknowledgement) in
            let comparsion = left.title.compare(right.title)
            return comparsion == .OrderedDescending
        }
            
        XCTAssert(viewController.acknowledgements == [d, c, b, a], "Custom sort did not produce an alphabetically descending sorted list.")
    }
    
    func testTableDataSourceNumberOfRows() {
        let count = viewController.tableView(viewController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(count, viewController.acknowledgements.count, "The number of rows returned by the UITableViewDataSource is invalid.")
    }
    
    func testTableDataSourceCellForRowAtIndexPath() {
        let cell = viewController.tableView(viewController.tableView, cellForRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertEqual(cell.textLabel!.text, viewController.acknowledgements[0].title)
    }
    
}
