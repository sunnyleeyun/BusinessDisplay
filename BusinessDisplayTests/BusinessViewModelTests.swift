//
//  BusinessViewModelTests.swift
//  BusinessDisplayTests
//
//  Created by 李昀 on 2024/1/11.
//

import XCTest

final class BusinessViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBusinessLoaded() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        XCTAssertNil(businessVM.business)
        await businessVM.getBusiness();
        XCTAssertEqual(businessVM.business!.locationName, "BEASTRO by Marshawn Lynch")
        XCTAssertEqual(businessVM.business!.hours.count, 9)
    }
    
    func testOpeningHours() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openingHours = businessVM.business!.openingHours()
        XCTAssertEqual(openingHours.count, 7)
        XCTAssertEqual(openingHours[0].1.count, 0)
        XCTAssertEqual(openingHours[1].1.count, 2)
        XCTAssertEqual(openingHours[2].1.count, 2)
        XCTAssertEqual(openingHours[3].1.count, 1)
        XCTAssertEqual(openingHours[4].1.count, 1)
        XCTAssertEqual(openingHours[5].1.count, 1)
        XCTAssertEqual(openingHours[6].1.count, 2)
    }
    
    func testOpenStatus1() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(currentTimestamp: 1705031145, periodCase: .LOWER) // 2024.01.11 22:45:45 (THU)
        XCTAssertEqual(openStatus, "Open until 12am")
    }
    
    func testOpenStatus2() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(currentTimestamp: 1705034700, periodCase: .LOWER) // 2024.01.11 23:45:00 (THU)
        XCTAssertEqual(openStatus, "Open until 12am, reopens at 7am")
    }
    
    func testOpenStatus3() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(currentTimestamp: 1705037410, periodCase: .LOWER) // 2024.01.12 00:30:10 (FRI)
        XCTAssertEqual(openStatus, "Opens again at 7am")
    }
    
    func testOpenStatus4() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(currentTimestamp: 1705293010, periodCase: .LOWER) // 2024.01.14 23:30:10 (SUN)
        XCTAssertEqual(openStatus, "Opens Tuesday 7am")
    }
    
    func testOpenStatus5() async {
        let mock = MockBusinessService()
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(currentTimestamp: 1705433410, periodCase: .LOWER) // 2024.01.16 14:30:10 (TUE)
        XCTAssertEqual(openStatus, "Opens again at 3pm")
    }
}
