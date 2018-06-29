//
//  NutritionTrackerTests.swift
//  NutritionTrackerTests
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import XCTest
@testable import NutritionTracker

class NutritionTrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	//MARK: FoodItem
	func testFoodItemInitTypical() {
		let foodItem = FoodItem(foodId: 1, name: "Butter")
		XCTAssert(foodItem.getFoodId() == 1)
		XCTAssert(foodItem.getName() == "Butter")
	}
	
	func testFoodItemUninitialized() {
		let foodItem = FoodItem()
		XCTAssert(foodItem.getFoodId() == -1)
		XCTAssert(foodItem.getName() == "uninitialized")
	}
	
	func testFoodItemInitNil() {
		let foodItem = FoodItem(foodId: nil, name: nil)
		XCTAssert(foodItem.getFoodId() == -1)
		XCTAssert(foodItem.getName() == "uninitialized")

		let foodItem2 = FoodItem(foodId: nil, name: "Butter")
		XCTAssert(foodItem2.getFoodId() == -1)
		XCTAssert(foodItem2.getName() == "Butter")
		
		let foodItem3 = FoodItem(foodId: 12345, name: nil)
		XCTAssert(foodItem3.getFoodId() == 12345)
		XCTAssert(foodItem3.getName() == "uninitialized")
	}
	
	
	//MARK: provided
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
