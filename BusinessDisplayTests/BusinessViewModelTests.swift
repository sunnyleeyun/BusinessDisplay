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
    
    @MainActor func testOpeningHours() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openingHours = businessVM.business!.openingHours()
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
    
    @MainActor func testOpenStatus1() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(from: 1705031145, periodCase: .LOWER) // 2024.01.11 22:45:45 (THU)
        // then
        XCTAssertEqual(openStatus.label, "Open until 12am")
        XCTAssertEqual(openStatus.color, .GREEN)
    }
    
    @MainActor func testOpenStatus2() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(from: 1705034700, periodCase: .LOWER) // 2024.01.11 23:45:00 (THU)
        // then
        XCTAssertEqual(openStatus.label, "Open until 12am, reopens at 7am")
        XCTAssertEqual(openStatus.color, .YELLOW)
    }
    
    @MainActor func testOpenStatus3() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(from: 1705037410, periodCase: .LOWER) // 2024.01.12 00:30:10 (FRI)
        // then
        XCTAssertEqual(openStatus.label, "Opens again at 7am")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
    @MainActor func testOpenStatus4() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(from: 1705293010, periodCase: .LOWER) // 2024.01.14 23:30:10 (SUN)
        // then
        XCTAssertEqual(openStatus.label, "Opens Tuesday 7am")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
    @MainActor func testOpenStatus5() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(from: 1705433410, periodCase: .LOWER) // 2024.01.16 14:30:10 (TUE)
        // then
        XCTAssertEqual(openStatus.label, "Opens again at 3pm")
        XCTAssertEqual(openStatus.color, .RED)
    }
    
    @MainActor func testOpenStatus6() async {
        // given
        let mock = MockBusinessService()
        // when
        let businessVM = BusinessViewModel(businessFetching: mock)
        await businessVM.getBusiness();
        let openStatus = businessVM.business!.openStatus(from: 1705433410, periodCase: .LOWER) // 2024.01.16 14:30:10 (TUE)
        // then
        XCTAssertEqual(openStatus.label, "Opens again at 3pm")
        XCTAssertEqual(openStatus.color, .RED)
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
