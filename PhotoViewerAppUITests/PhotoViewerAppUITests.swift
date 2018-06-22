//
//  PhotoViewerAppUITests.swift
//  PhotoViewerAppUITests
//
//  Created by Antonov, Pavel on 6/14/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import XCTest
import Nimble

class PhotoViewerAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUiElementCounts() {
        XCTAssertGreaterThan(XCUIApplication().collectionViews.cells.count, 0)
        let cell = XCUIApplication().collectionViews.cells.element(boundBy: 3)
        XCTAssertEqual(cell.staticTexts.count, 3)
        XCTAssertEqual(cell.images.count, 1)
    }
    
    func testTransitionFromCell() {
        let cell = XCUIApplication().collectionViews.cells.element(boundBy: 3)
        let owner = cell.staticTexts.element(boundBy: 1).label
        let description = cell.staticTexts.element(boundBy: 2).label
        cell.tap()
        
        waitUntil(timeout: 3.0, action: { done in
            XCTAssertEqual(XCUIApplication().scrollViews.count, 1)
            XCTAssertEqual(XCUIApplication().images.count, 1)
            XCTAssertEqual(XCUIApplication().staticTexts.count, 2)
            
            let ownerDetail = XCUIApplication().staticTexts.element(boundBy: 0).label
            let descriptionDetail = XCUIApplication().staticTexts.element(boundBy: 1).label
            
            expect(ownerDetail).to(equal(owner))
            expect(descriptionDetail).to(equal(description))
            done()
        })
    }
    
}
