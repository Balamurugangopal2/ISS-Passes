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
    
    var issPassesListViewModel: IssPassesListViewModel?
    
    override func setUp() {
        super.setUp()
        issPassesListViewModel = IssPassesListViewModel()
        let passRequest = PassRequest(latitude: 41.8717945274356, longitude: -72.6550873742184, altitude: 100, passes: 5, datetime: Date(timeIntervalSince1970: TimeInterval(1518884641)))
        let passResponse1 = PassResponse(duration: 565, risetime: 1518889668)
        let passResponse2 = PassResponse(duration: 605, risetime: 1518895489)
        issPassesListViewModel?.issPasses = IssPasses(message: "Success", request: passRequest, response: [passResponse1, passResponse2])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_getLatidude() {
        XCTAssertEqual(issPassesListViewModel?.getLatitude(), "41.8717945274356")
    }
    
    func test_getAltitude() {
        XCTAssertEqual(issPassesListViewModel?.getAltitude(), "100.0")
    }
    
    func test_getLongitude() {
        XCTAssertEqual(issPassesListViewModel?.getLongitude(), "-72.6550873742184")
    }
    
    func test_getNoOfPasses() {
        XCTAssertEqual(issPassesListViewModel?.getNoOfPasses(), "5")
    }
    
    func test_numberofItemsInSection() {
        XCTAssertEqual(issPassesListViewModel?.numberofItemsInSection(section: 0), 2)
    }
    
    func test_fetchIssPassesList() {
        let expectation = XCTestExpectation(description: "fetchPassesCompletion")
        guard let latitude = issPassesListViewModel?.getLatitude(), let longitude = issPassesListViewModel?.getLongitude() else {
            XCTAssert(false)
            return
        }
        let parameter = "lat=\(latitude)&lon=\(longitude)"
        issPassesListViewModel?.issApi.fetchIssPassesList(parameter: parameter, completion: { (issPassesList, error) in
            XCTAssertNotNil(issPassesList)
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
    }
}
