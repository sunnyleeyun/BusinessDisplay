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

    @MainActor func testBusinessBeforeLoaded() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        // then
        XCTAssertNil(businessVM.business)
    }
    
    @MainActor func testBusinessLoaded() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        // then
        XCTAssertEqual(businessVM.business!.locationName, "BEASTRO by Marshawn Lynch")
        XCTAssertEqual(businessVM.business!.hours.count, 9)
    }
    
    @MainActor func testformattedOpeningHours0() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let formattedOpeningHours = businessVM.business!.formattedOpeningHours(from: 1705034700) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(formattedOpeningHours.count, 10)
    }
    
    @MainActor func testformattedOpeningHours1() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let formattedOpeningHours = businessVM.business!.formattedOpeningHours(from: 1705034700) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(formattedOpeningHours[0].day, "Monday")
        XCTAssertEqual(formattedOpeningHours[0].hours, "Closed")
        XCTAssertEqual(formattedOpeningHours[0].isBold, false)
    }
    
    @MainActor func testformattedOpeningHours2() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let formattedOpeningHours = businessVM.business!.formattedOpeningHours(from: 1705034700) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(formattedOpeningHours[1].day, "Tuesday")
        XCTAssertEqual(formattedOpeningHours[1].hours, "7am-1pm")
        XCTAssertEqual(formattedOpeningHours[1].isBold, false)
        XCTAssertEqual(formattedOpeningHours[2].day, "")
        XCTAssertEqual(formattedOpeningHours[2].hours, "3pm-10pm")
        XCTAssertEqual(formattedOpeningHours[2].isBold, false)
    }
    
    @MainActor func testformattedOpeningHours3() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let formattedOpeningHours = businessVM.business!.formattedOpeningHours(from: 1705034700) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(formattedOpeningHours[3].day, "Wednesday")
        XCTAssertEqual(formattedOpeningHours[3].hours, "7am-1pm")
        XCTAssertEqual(formattedOpeningHours[3].isBold, false)
        XCTAssertEqual(formattedOpeningHours[4].day, "")
        XCTAssertEqual(formattedOpeningHours[4].hours, "3pm-10pm")
        XCTAssertEqual(formattedOpeningHours[4].isBold, false)
    }
    
    @MainActor func testformattedOpeningHours4() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let formattedOpeningHours = businessVM.business!.formattedOpeningHours(from: 1705034700) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(formattedOpeningHours[5].day, "Thursday")
        XCTAssertEqual(formattedOpeningHours[5].hours, "Open 24hrs")
        XCTAssertEqual(formattedOpeningHours[5].isBold, true)
    }
    
    
}
