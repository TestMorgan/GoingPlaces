//
//  GoingPlacesTests.swift
//  GoingPlacesTests
//
//  Created by Morgan Collino on 11/1/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import XCTest
@testable import GoingPlaces

class GoingPlacesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpenURL() {
        let deepLinkManager = DeepLinkManager()
        let result = deepLinkManager.canOpenURL(url: URL(string: "goingplaces://openLocation?from=__morgan__&location=40.6875012,-73.9796053&name=Flatbush%20Jewelry%20Exchange&address=41%20Flatbush%20Ave%20%235,%20Brooklyn,%20NY%2011217,%20USA")!)
        XCTAssertTrue(result)
    }
    
    func testOpenBadURL() {
        let deepLinkManager = DeepLinkManager()
        let result = deepLinkManager.canOpenURL(url: URL(string: "goingplaces://what/really?")!)
        XCTAssertFalse(result)
    }
    
}
