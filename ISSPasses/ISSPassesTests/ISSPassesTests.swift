//
//  ISSPassesTests.swift
//  ISSPassesTests
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//

import XCTest
@testable import ISSPasses

class ISSPassesTests: XCTestCase {
    
    var passesListViewModel: PassesListViewModel?
    
    override func setUp() {
        super.setUp()
        passesListViewModel = PassesListViewModel()
        let passRequest = PassRequest(latitude: 41.8717945274356, longitude: -72.6550873742184, altitude: 100, passes: 5, datetime: Date(timeIntervalSince1970: TimeInterval(1518884641)))
        let passResponse1 = PassResponse(duration: 565, risetime: Date(timeIntervalSince1970: TimeInterval(1518889668)))
        let passResponse2 = PassResponse(duration: 605, risetime: Date(timeIntervalSince1970: TimeInterval(1518895489)))
        passesListViewModel?.passes = Passes(message: "Success", request: passRequest , response: [passResponse1, passResponse2])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_getLatidude() {
        XCTAssertEqual(passesListViewModel?.getLatitude(), "41.8717945274356")
    }
    
    func test_getAltitude() {
        XCTAssertEqual(passesListViewModel?.getAltitude(), "100.0")
    }
    
    func test_getLongitude() {
        XCTAssertEqual(passesListViewModel?.getLongitude(), "-72.6550873742184")
    }
    
    func test_getNoOfPasses() {
        XCTAssertEqual(passesListViewModel?.getNoOfPasses(), "5")
    }
    
    func test_numberofItemsInSection() {
        XCTAssertEqual(passesListViewModel?.numberofItemsInSection(section: 0), 2)
    }
}