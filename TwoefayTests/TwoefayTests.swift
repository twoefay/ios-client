//
//  TwoefayTests.swift
//  TwoefayTests
//
//  Created by Chris Orcutt on 4/20/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import XCTest
@testable import Twoefay

class TwoefayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDateFunction () {
        let dateString = LoginRequestManager.getTimeString()
        print(dateString)
        XCTAssert(dateString.characters.count == 19)
    }
    
    func testLocation() {
        let ip = "208.80.152.201"
        var location = "Los Angeles"
        AlamoManager.locationFromIP(ip, completionHandler: { stringy in
            if let foundLocation = stringy {
                location = foundLocation
            }
            print("Location from Call: \(location)")
            XCTAssert(location == "San Francisco, United States")
        })
    }
    
    
    
}
