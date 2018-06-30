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
		let foodItem = FoodItem(1, "Butter")
		XCTAssert(foodItem.getFoodId() == 1)
		XCTAssert(foodItem.getName() == "Butter")
	}
	
	func testFoodItemUninitialized() {
		let foodItem = FoodItem()
		XCTAssert(foodItem.getFoodId() == -1)
		XCTAssert(foodItem.getName() == "uninitialized")
	}
	
	func testFoodItemInitNil() {
		let foodItem = FoodItem(nil, nil)
		XCTAssert(foodItem.getFoodId() == -1)
		XCTAssert(foodItem.getName() == "uninitialized")

		let foodItem2 = FoodItem(nil, "Butter")
		XCTAssert(foodItem2.getFoodId() == -1)
		XCTAssert(foodItem2.getName() == "Butter")
		
		let foodItem3 = FoodItem(12345, nil)
		XCTAssert(foodItem3.getFoodId() == 12345)
		XCTAssert(foodItem3.getName() == "uninitialized")
	}
	
	// MARK: FoodItemList
	func testFoodItemList() {
		let foodList = FoodItemList()
		XCTAssert(foodList.count() == 0)

		//add items to list
		for i in 0..<5 {
			let foodItem = FoodItem(i, "food")
			foodList.add(foodItem)
			XCTAssert(foodList.count() == i+1)
		}

		//test list
		XCTAssert(foodList.count() == 5)
		for i in 0..<5 {
			let foodItem = foodList.get(i)
			XCTAssert(foodItem!.getFoodId() == i)
			XCTAssert(foodItem!.getName() == "food")
			XCTAssert(foodList.validIndex(i))
			XCTAssert(foodList.count() == 5)
		}
		XCTAssertNil(foodList.get(5))
		XCTAssert(!foodList.validIndex(5))

		//remove items from list
		for i in 0..<5 {
			foodList.remove(0)
			XCTAssert(foodList.count() == 5-1-i)
		}
		//XCTAssertNil(foodList.remove(0))
	}
	
	//MARK: Amount
	func testAmountDefault() {
		let amount = Amount()
		XCTAssert(amount.getAmount() == 0.0 as Float)
		XCTAssert(amount.getUnit() == Unit.Miligram)
	}
	func testAmountInit() {
		let amount = Amount(5.0, NutritionTracker.Unit.Microgram)
		XCTAssert(amount.getAmount() == 5.0 as Float)
		XCTAssert(amount.getUnit() == NutritionTracker.Unit.Microgram)
	}
	func testAmountGetSet() {
		let amount = Amount()
		amount.setAmount(-1.0)
		XCTAssert(amount.getAmount() == 0.0 as Float)
		amount.setAmount(5.0)
		amount.setUnit(NutritionTracker.Unit.Microgram)
		XCTAssert(amount.getAmount() == 5.0 as Float)
		XCTAssert(amount.getUnit() == NutritionTracker.Unit.Microgram)
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
