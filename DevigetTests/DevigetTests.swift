//
//  DevigetTests.swift
//  DevigetTests
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import XCTest
@testable import Deviget

class DevigetTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAllReditPost() {
        let serv = EntryService()
        
        let completedExpectation = expectation(description: "Completed")
        var entriesResponse : [Entry]?

        var errorMsgResponse : String?
        serv.getTopEntries(limit:50) {(entries,nextpage, errorMsg) in
            entriesResponse = entries
            errorMsgResponse = errorMsg
            completedExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(entriesResponse)
        XCTAssertNil(errorMsgResponse)
        XCTAssertTrue(entriesResponse?.count ?? 0 == 50)
    }

    func testGetPaginatedReditPost() {
        let serv = EntryService()
        
        let completedExpectation = expectation(description: "Completed")
        
        
        let limit = 10
        var entriesResponsePage1 : [Entry]?
        var nextPage1 : String?
        var errorMsgResponsePage1 : String?
        var entriesResponsePage2 : [Entry]?
        var nextPage2 : String?
        var errorMsgResponsePage2 : String?
        serv.getTopEntries(limit:limit) {(entries,nextpage, errorMsg) in
            entriesResponsePage1 = entries
            nextPage1 = nextpage
            errorMsgResponsePage1 = errorMsg
            serv.getTopEntries(after:nextpage, limit:limit) {(entries,nextpage, errorMsg) in
                entriesResponsePage2 = entries
                nextPage2 = nextpage
                errorMsgResponsePage2 = errorMsg
                completedExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(nextPage1 != nextPage2)
        XCTAssertNotNil(entriesResponsePage1)
        XCTAssertNil(errorMsgResponsePage1)
        XCTAssertTrue(entriesResponsePage1?.count ?? 0 == limit)
        XCTAssertNotNil(entriesResponsePage2)
        XCTAssertNil(errorMsgResponsePage2)
        XCTAssertTrue(entriesResponsePage2?.count ?? 0 == limit)
    }
}
