//
//  BusinessTests.swift
//  BusinessDisplayTests
//
//  Created by 李昀 on 2024/1/13.
//

import XCTest

final class BusinessTests: XCTestCase {
    var sut: Business!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = try StubBusinessModel().getBusiness()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testLocationExistence() throws {
        // given
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "location", withExtension: "json") else {
            XCTFail("Missing file: location.json")
            return
        }
        
        // when
        let json = try Data(contentsOf: url)
        let business = try JSONDecoder().decode(Business.self, from: json)
        
        // then
        XCTAssertNotNil(business)
        XCTAssertEqual(business.locationName, "BEASTRO by Marshawn Lynch")
        XCTAssertEqual(business.hours.count, 9)
    }
    
    func testOpeningHours() {
        // given, when
        let openingHours = sut.openingHours()
        // then
        XCTAssertEqual(openingHours.count, 7)
        XCTAssertEqual(openingHours[0].1.count, 0)
        XCTAssertEqual(openingHours[1].1.count, 2)
        XCTAssertEqual(openingHours[2].1.count, 2)
        XCTAssertEqual(openingHours[3].1.count, 1)
        XCTAssertEqual(openingHours[4].1.count, 1)
        XCTAssertEqual(openingHours[5].1.count, 1)
        XCTAssertEqual(openingHours[6].1.count, 2)
    }
    
    func testOpenStatus1() {
        // given, when
        let openStatus = sut.openStatus(from: 1705031145, periodCase: .LOWER) // 2024.01.11 22:45:45 (THU)
        // then
        XCTAssertEqual(openStatus.label, "Open until 12am")
        XCTAssertEqual(openStatus.color, .GREEN)
    }
    
    func testOpenStatus2() {
        // given, when
        let openStatus = sut.openStatus(from: 1705034700, periodCase: .LOWER) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(openStatus.label, "Open until 12am, reopens at 7am")
        XCTAssertEqual(openStatus.color, .YELLOW)
    }
    
    func testOpenStatus3() {
        // given, when
        let openStatus = sut.openStatus(from: 1705037410, periodCase: .LOWER) // 2024.01.12 00:30:10 (FRI)
        // then
        XCTAssertEqual(openStatus.label, "Opens again at 7am")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
    func testOpenStatus4() {
        // given, when
        let openStatus = sut.openStatus(from: 1705293010, periodCase: .LOWER) // 2024.01.14 23:30:10 (SUN)
        // then
        XCTAssertEqual(openStatus.label, "Opens Tuesday 7am")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
    func testOpenStatus5() {
        // given, when
        let openStatus = sut.openStatus(from: 1705433410, periodCase: .LOWER) // 2024.01.16 14:30:10 (TUE)
        // then
        XCTAssertEqual(openStatus.label, "Opens again at 3pm")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
    func testOpenStatus6() {
        // given, when
        let openStatus = sut.openStatus(from: 1705433410, periodCase: .LOWER) // 2024.01.16 14:30:10 (TUE)
        // then
        XCTAssertEqual(openStatus.label, "Opens again at 3pm")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
}
