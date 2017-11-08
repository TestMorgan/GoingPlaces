//
//  PlaceTests.swift
//  GoingPlacesTests
//
//  Created by Morgan Collino on 11/7/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import XCTest

class PlaceTests: XCTestCase {
 
    func testValidURLParameters() {
        let parameters = ["location": "42,42",
                          "name": "Morgan's place",
                          "address": "This is a test",
                          "from": "Test"]
        let place = Place.fromURLParameters(values: parameters)
        XCTAssertNotNil(place)
    }
    
    func testInvalidURLParameters() {
        let parameters = ["name": "Morgan's place",
                          "address": "This is a test",
                          "from": "Test"]
        let place = Place.fromURLParameters(values: parameters)
        XCTAssertNil(place)
    }
    
}
