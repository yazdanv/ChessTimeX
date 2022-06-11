//
//  XCTestExtension.swift
//  ChessTimeXTests
//
//  Created by Yazdan on 6/11/22.
//

import XCTest
import Combine

extension XCTestCase {
    func testPublisherTillMatch<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 5,
        assertMessage: String = "",
        runBeforeWait: (() -> Void)? = nil,
        test: @escaping (T.Output) -> Bool
    ) {
        let expectation = self.expectation(description: assertMessage)

        let disposable = publisher
            .first(where: test)
            .sink(receiveCompletion: { _ in }) { _ in
                expectation.fulfill()
            }
        
        runBeforeWait?()
        waitForExpectations(timeout: timeout)
        disposable.cancel()
    }
}
