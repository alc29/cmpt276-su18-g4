//
//  NutritionTrackerTests.swift
//  NutritionTrackerTests
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import XCTest
import RealmSwift

@testable import NutritionTracker

class NutritionTrackerTests: XCTestCase {
	
	// Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUp() {
        super.setUp()
		//clearRealm()
    }

	// Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDown() {
        super.tearDown()
		//clearRealm()
    }
	
	func clearRealm() {
		DispatchQueue(label: "NutrientTrackerTests").async {
			let realm = try! Realm()
			XCTAssertNotNil(realm)
			try! realm.write {
				realm.deleteAll()
			}
		}
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

	
	//MARK: - Test FoodGroup class
	func testFoodGroup_getIdStr() {
		let dairy = FoodGroup.Dairy_and_Egg_Products
		let nativeFoods = FoodGroup.American_Indian_Alaska_Native_Foods
		XCTAssert(dairy.getIdStr() == "0100")
		XCTAssert(nativeFoods.getIdStr() == "2400")
	}
	
	
	// MARK: FoodReportV1 tests
	func testFoodReportV1() {
		let poop = FoodItem(45144608, "poop") // v0.0
		let cheese = FoodItem(01009, "cheese") // legacy
		let expectationPoop = XCTestExpectation(description: "poop food report v1 completes")
		let expectationCheese = XCTestExpectation(description: "cheese food report v1 completes")

		let completionPoop: (FoodReportV1?) -> Void = { (foodReport: FoodReportV1?) -> Void in
			XCTAssertNotNil(foodReport!)
			XCTAssertNotNil(foodReport!.result!)

			let result = foodReport!.result as! FoodReportV1.Result
			let report = result.report
			XCTAssert(report!.sr == "v0.0 June, 2018", report!.sr!)
			expectationPoop.fulfill()
		}
		
		let completionCheese: (FoodReportV1?) -> Void = { (foodReport: FoodReportV1?) -> Void in
			XCTAssertNotNil(foodReport!)
			XCTAssertNotNil(foodReport!.result!)
			
			let result = foodReport!.result as! FoodReportV1.LegacyResult
			let report = result.report
			XCTAssertNotNil(report!)
			XCTAssert(report!.sr == "Legacy", report!.sr!)
			expectationCheese.fulfill()
		}

		Database5.requestFoodReportV1(poop, completionPoop, false)
		wait(for: [expectationPoop], timeout: 15)
		
		Database5.requestFoodReportV1(cheese, completionCheese, false)
		wait(for: [expectationCheese], timeout: 15)
	}
	
	
	
	// MARK: - Persistence Tests

	func testSaveMeal() {
		let meal = Meal()
		let poopId = 45144608
		meal.add(FoodItem(poopId, "poop candy"))
		meal.add(FoodItem(2, "second"))
		let expectation = XCTestExpectation(description: "completion completes")
		let completion: (Bool) -> Void = { (success: Bool) -> Void in
			expectation.fulfill()
			XCTAssert(success)
		}
		
		MealBuilderViewController().saveMeal(meal, completion, false) // TODO use completion for testing cachedFoodItem
		wait(for: [expectation], timeout: 3)
		
		let mealsCompletionInvoked = XCTestExpectation()
		let mealsCompletion: ([Meal]) -> Void = { (meals: [Meal]) -> Void in
			XCTAssert(meals.count == 1)
			let foodItems = meals.first!.getFoodItems()
			XCTAssert(foodItems.count == 2)

			let poopCandy = foodItems[0]
			let second = foodItems[1]
			XCTAssert(poopCandy.getFoodId() == poopId)
			XCTAssert(second.getFoodId() == 2)
			
			mealsCompletionInvoked.fulfill()
		}
		
		Database5.getSavedMeals(mealsCompletion)
		wait(for: [mealsCompletionInvoked], timeout: 5)
	}
	
	func testCacheFoodItem() {
		let ID = 45144608
		let nutrientToGet = Nutrient.Sugars_total
		let expectedSugarsTotal: Float = 80.49
		//NOTE adding unresolved expectations & waits introduces Realm exception - realm from incorrect thread

		
		//test successful cache
		let expectation = XCTestExpectation(description: "cacheFoodItem completes")
		let completion: (Bool) -> Void = { (success: Bool) -> Void in
			expectation.fulfill()
			XCTAssert(success)
		}
		MealBuilderViewController().cacheFoodItem(FoodItem(ID, "poop candy"), completion, false)
		wait(for: [expectation], timeout: 3)

		
		//test getting cached item
		let getCachedFoodItemExpectation = XCTestExpectation(description: "getCachedFoodItem completes")
		
		let getCachedCompletion: (CachedFoodItem?) -> Void = { (cachedFoodItem: CachedFoodItem?) -> Void in
			getCachedFoodItemExpectation.fulfill()
			
			guard let cachedFoodItem = cachedFoodItem else { XCTAssert(false); return } //TODO sometimes failes
			guard let foodItemNutrient = cachedFoodItem.getFoodItemNutrient(nutrientToGet) else { XCTAssert(false); return }
			let amount = foodItemNutrient.getAmount()
			XCTAssert(amount.isEqual(to: expectedSugarsTotal), String(amount))
			XCTAssert(cachedFoodItem.getFoodId() == ID)
			XCTAssert(cachedFoodItem.nutrients.count > 0)
		}
		
		Database5.getCachedFoodItem(ID, getCachedCompletion, false)
		wait(for: [expectation], timeout: 5)
	}
	

	//TODO test for multiple food items
//	func testGetCacheFoodItems() {
//
//	}
	

	//MARK: Performance
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


