//
//  SwiftTestingDemoTests.swift
//  SwiftTestingDemoTests
//
//  Created by LM on 2024/12/2.
//

import Testing
@testable import SwiftTestingDemo

struct SwiftTestingDemoTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(2 > 1)
    }
}
