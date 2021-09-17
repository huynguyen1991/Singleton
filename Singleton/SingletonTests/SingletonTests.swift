//
//  SingletonTests.swift
//  SingletonTests
//
//  Created by Huy Nguyễn on 16/09/2021.
//

import XCTest
@testable import Singleton

class SingletonTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testConcurrentUsge() throws {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        let expect = expectation(description: "Multiple threads access event logger")
        let iterations = 100
        for concurrentIteration in 1...iterations {
            concurrentQueue.async {
                let key = "\(concurrentIteration)"
                EventLogger.shared.writeToLog(key: key, content: key)
            }
        }
        
        while EventLogger.shared.readLog(for: "\(iterations)") != "\(iterations)" {
        }
        
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Concurrent expection ")
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
