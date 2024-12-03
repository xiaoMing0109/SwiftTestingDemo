//
//  SwiftTestingNewTraitsTests.swift
//  AudioPlaybackManager_Tests
//
//  Created by LM on 2024/11/29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Testing

// MARK: - Macros

struct SwiftTestingMacrosTests {
    
    // MARK: throws

    struct TestEntity {
        enum CalculationError: Swift.Error, Equatable {
            case divisionByZero
        }
        
        func division(_ a: Int, _ b: Int) throws -> Int {
            guard b != 0 else {
                throw CalculationError.divisionByZero
            }
            return a / b
        }
    }

    @Test func testThrowErrors() throws {
        let sut = TestEntity()
        
        #expect(throws: (any Error).self) {
            try sut.division(1, 0)
        }
        
        #expect(throws: TestEntity.CalculationError.divisionByZero) {
            try sut.division(1, 0)
        }
        
        #expect {
            try sut.division(1, 0)
        } throws: { error in
            guard let error = error as? TestEntity.CalculationError,
                  case .divisionByZero = error else {
                return false
            }
            return true
        }
        
        try #require(throws: (any Error).self) {
            try sut.division(1, 0)
        }
    }

    // MARK: #require

    @Test func testOptionalValue() throws {
        let optionValue: Int? = 0
        let unwrapValue = try #require(optionValue)
        #expect(unwrapValue != nil)
        
        let nilValue: Int? = nil
        // Warning: Test failure to open this comment!!!
    //        let _ = try #require(nilValue, "`nilValue` is nil.")
    }
}

// MARK: - Traits

// MARK: Custom Name

@Test("这里可以自定义测试方法名")
func renameTestFunction() {
    var boolValue = false
    #expect(!boolValue)
    
    boolValue = true
    #expect(boolValue)
}

// MARK: Tag

extension Tag {
    @Tag static var formatting: Self
    @Tag static var networking: Self
}

@Test(.tags(.formatting))
func tagSampleTest1()  {
    let a = 2
    #expect(a < 3)
}

@Test(.tags(.networking, .formatting))
func tagSampleTest2() throws {
    let a = 2
    try #require(a < 3)
}

extension Tag {
    @Tag static var isNew: Self
}

@Suite(.tags(.isNew)) struct TagTests {
    
    @Test func tagSampleTest1() throws {
        let a = 2
        try #require(a < 3)
    }
    
    @Test func tagSampleTest2() throws {
        let a = 2
        try #require(a < 3)
    }
}

// MARK: Enabled & Disabled

/// Modify this value to change test enable state.
let isTestEnabled: Bool = false

@Test(.enabled(if: isTestEnabled)) func testFuncEnabled() {
    // ✘ Test testFuncEnabled() skipped.
}

@Test(.disabled(if: !isTestEnabled)) func testFuncDisabled() {
    // ✘ Test testFuncDisabled() skipped.
}

// MARK: TimeLimit

@available(iOS 16.0, *)
@Test(.timeLimit(.minutes(1)))
func testTimeLimit() async throws {
    let sleepTime = 1// Modify it to greate than 60 will be failed.
    try await Task.sleep(for: .seconds(sleepTime))
}

// MARK: Serialized

@Suite(.serialized)
struct SerializedTests {
    
    @Test func serializedSampleTest1() throws {
        let a = 2
        try #require(a < 3)
    }
    
    @Test func serializedSampleTest2() throws {
        let a = 2
        try #require(a < 3)
    }
    
    @Test func serializedSampleTest3() throws {
        let a = 2
        try #require(a < 3)
    }
}

// MARK: - Others

// MARK: Parameterized tests to the rescue

struct IceCream {
    enum Flavor {
        case vanilla, chocolate, strawberry, mint, banana, pistachio, peanut
        
        var containsNuts: Bool {
            switch self {
            case .peanut, .pistachio:
                return true
            default:
                return false
            }
        }
    }
}

@Test(arguments: [IceCream.Flavor.vanilla, .chocolate, .strawberry, .mint, .banana])
func doesNotContainNuts(flavor: IceCream.Flavor) throws {
    try #require(!flavor.containsNuts)
}

/**
 enum Ingredient: CaseIterable {
     case rice, potato, lettuce, egg
 }

 enum Dish: CaseIterable {
     case onigiri, fries, salad, omelette
 }

 // Without zip there are 16 test cases (all combination of the 2 sets of 4 elements)
 @Test(arguments: Ingredient.allCases, Dish.allCases)
 func cook(_ ingredient: Ingredient, into dish: Dish) async throws {
     #expect(ingredient.isFresh)
     let result = try cook(ingredient)
     try #require(result.isDelicious)
     try #require(result == dish)
 }

 // Zipped to 4 test cases
 @Test(arguments: zip(Ingredient.allCases, Dish.allCases))
 func cook(_ ingredient: Ingredient, into dish: Dish) async throws {
     #expect(ingredient.isFresh)
     let result = try cook(ingredient)
     try #require(result.isDelicious)
     try #require(result
 }
 */

// MARK: Confirmation

class ConfirmationEvent {
    var eventHandler: (() -> Void)?
    
    func action(count: Int) async {
        (0..<count).forEach { _ in
            eventHandler?()
        }
    }
}

@available(iOS 13.0, *)
@Test func testConfirmation() async throws {
    let confirmationEvent = ConfirmationEvent()
    
    let n = 10
    await confirmation("Event times.", expectedCount: n) { confirm in
        confirmationEvent.eventHandler = {
            confirm()
        }
        await confirmationEvent.action(count: n)
    }
}
