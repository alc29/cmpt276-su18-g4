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
	
	
	
	// MARK: - FoodDataCache Tests
	
	func testSavedMeal() {
		//TODO left off here
	}
	
	//check CachedFoodItem
	func testCachedFoodItem() {
		let ID = 45144608
		let nutrientToGet = Nutrient.Sugars_total
		let expectedSugarsTotal: Float = 80.49
		let expectation = XCTestExpectation(description: "completion is called")
		let waitEx = XCTestExpectation(description: "need wait")
		
		let completion: (FoodReportV1?) -> Void = { (foodReport: FoodReportV1?) -> Void in
			XCTAssertNotNil(foodReport!)
			expectation.fulfill()
		}
		
		Database5.requestFoodReportV1(FoodItem(ID, "poop candy"), completion)
		wait(for: [expectation], timeout: 15)
		wait(for: [waitEx], timeout: 3)
		
		let realm = try! Realm() //clear realm data
		let results = realm.objects(CachedFoodItem.self)
		XCTAssert(results.count == 1) //TODO assertion not working
		
		//Test nutrient value
		print(String(describing: results))
		if let cachedFoodItem = results.first {
			let foodItemNutrient = cachedFoodItem.getFoodItemNutrient(nutrientToGet)!
			let amount = foodItemNutrient.getAmount()
			XCTAssert(amount.isEqual(to: expectedSugarsTotal), String(amount))
			//print(String(describing:cachedFoodItem))
			
			XCTAssert(cachedFoodItem.getFoodId() == ID)
			XCTAssert(cachedFoodItem.nutrients.count > 0)
			
			//print(String(describing: cachedFoodItem.nutrients.first))
			//print(cachedFoodItem.nutrients.count)
			
			//let foodItemNutrient = cachedFoodItem.getFoodItemNutrient(nutrientToGet)
			//XCTAssertNotNil(foodItemNutrient!)
			//XCTAssert(foodItemNutrient!.getBaseAmount().getAmount().isEqual(to: Float(expectedSugarsTotal)))
			//TODO handle nutrient not found, using Nutrient.Nil
		} else {
			XCTAssert(false)
		}
		
	}
	
	func testSaveMeal() {
		let ID = 45144608
		let nutrientToGet = Nutrient.Sugars_total
		let expectedSugarsTotal: Float = 80.49
		//let expectation = XCTestExpectation(description: "completion is called")
		
		let meal = Meal()
		meal.add(FoodItem(ID, "poop candy"))
		MealBuilderViewController().saveMeal(meal, true)
		//wait(for: [expectation], timeout: 3)

		let cachedFoodItem = Database5.getCachedFoodItem(ID)!
		let foodItemNutrient = cachedFoodItem.getFoodItemNutrient(nutrientToGet)
		let unwrapped = foodItemNutrient!
		let amount = unwrapped.getAmount()
		XCTAssert(amount.isEqual(to: expectedSugarsTotal), String(amount))
		XCTAssert(cachedFoodItem.getFoodId() == ID)
		XCTAssert(cachedFoodItem.nutrients.count > 0)

		let sugars = meal.getAmountOf(nutrientToGet)
		XCTAssert(sugars.isEqual(to: expectedSugarsTotal))
		print("sugars: \(sugars)")
		
	}
	
	
	//MARK: - FoodReportV2 tests
//	func testFoodReportV2() {
//		let foods = [
//			FoodItem(01009, "testFoodreportV2"),  //cheddar cheese
//			//FoodItem(45202763, "testFoodreportV2"), //TODO handle no such food id
//			FoodItem(35193, "testFoodreportV2") //cooked agave
//		]
//
//		let expectation = XCTestExpectation(description: "Test Food Report V2")
//		let completion: (FoodReportV2?) -> Void = { (report: FoodReportV2?) -> Void in
//			//XCTAssertNotNil(report!) // TODO uncomment
//			//XCTAssert(report!.count() == 2)
//			expectation.fulfill()
//		}
//
//		Database5.requestFoodReportV2(foods, completion, false)
//		wait(for: [expectation], timeout: 15.0)
//	}
//	func testFoodReportV2_nutrients() { //test json parsing for nutrients
//		let foodItem = FoodItem(45144608, "poop candy") //poop candy
//
//		let expectation = XCTestExpectation(description: "completion invoked")
//		let completion:(FoodReportV2?) -> Void = { (report: FoodReportV2?) -> Void in
//			guard let report = report else { print("nil report"); return }
//			print("done")
//			print("num foods:\(report.jFoods.count)")
//			//guard let poop = report.jFoods.first else { return }
//			//print("poop: \(String(describing: poop))")
//
//			//print("result: \(String(describing: report.result))")
//
//			XCTAssertNotNil(report.result!)
//			let result = report.result!
//			XCTAssert(result.count == 1)
//			XCTAssert(result.notfound == 0)
//			XCTAssert(result.api == 2)
//
//			XCTAssertNotNil(result.foods!)
//			let jFoodContainers = result.foods!
//			XCTAssertNotNil(jFoodContainers.first!)
//			let jFoodContainer = jFoodContainers.first!
//			XCTAssertNotNil(jFoodContainer!)
//			XCTAssertNotNil(jFoodContainer!.food!)
//
//			let jFood = jFoodContainer!.food!
//			XCTAssert(jFood.sr! == "v0.0 March, 2018")
//			XCTAssert(jFood.type == "b")
//			XCTAssertNotNil(jFood.desc!)
//			let desc = jFood.desc!
//			XCTAssert(desc.ndbno! == "45144608")
//			XCTAssert(desc.name! == "CLEVER CANDY, EASTER BUNNY POOP ASSORTED JELLY BEANS, UPC: 618645313906")
//
//			XCTAssertNotNil(jFood.nutrients!)
//			let nutrients = jFood.nutrients!
//			XCTAssertNotNil(nutrients.first!)
//			let firstNutrient = nutrients.first!
//
//
//			let nutrientId = Int(firstNutrient!.nutrient_id!)
//			XCTAssert(nutrientId! == 208)
//
//			expectation.fulfill()
//		}
//
//		Database5.requestFoodReportV2([foodItem], completion, false)
//		wait(for: [expectation], timeout: 15.0)
//	}
	
	// MARK: FoodReportV2
//	func testDatabaseAndFoodDataCache() {
//		let foodId = 45144608
//		let foodItem = FoodItem(foodId, "Poop candy")
//		let expectation = XCTestExpectation(description: "FoodReportV2 request completion is called.")
//
//		let completion:(FoodReportV2?) -> Void = { (report: FoodReportV2?) -> Void in
//			XCTAssertNotNil(report!)
//
//			let retrievedItem = Database5.getCachedFoodItem(foodId)
//			print("retrieved item: \(String(describing: retrievedItem))")
//			XCTAssertNotNil(retrievedItem!)
//			XCTAssert(retrievedItem!.getFoodId() == foodId)
//
//			expectation.fulfill()
//		}
//
//		Database5.requestFoodReportV2([foodItem], completion, false)
//		wait(for: [expectation], timeout: 10.0)
//	}
	
//	func testNutritionCacheValues() {
//		let foodId = 45144608
//		let foodItem = FoodItem(foodId, "Poop candy")
//		let nutrient = Nutrient.Sugars_total
//		let expectation = XCTestExpectation(description: "FoodReportV2 request completion is called.")
//		
//		let completion:(FoodReportV2?) -> Void = { (report: FoodReportV2?) -> Void in
//			XCTAssertNotNil(report!)
//			
//			let sugarsTotal = foodItem.getAmountOf(nutrient)
//			XCTAssert(sugarsTotal == 80.49, String(describing: sugarsTotal))
//			
//			expectation.fulfill()
//		}
//		
//		Database5.requestFoodReportV2([foodItem], completion, false)
//		wait(for: [expectation], timeout: 10.0)
//	}

	// MARK: - Nutrient Report
//	func testNutrientReport() {
//		let tunaFoodId = 15117
//		let nutrients = [Nutrient.Calcium, Nutrient.Protein]
//		let expectation = XCTestExpectation(description: "Test Nutrient Report")
//
//		let completion: (NutrientReport?) -> Void = { (report: NutrientReport?) -> Void in
//			let realm = try! Realm()
//
//			XCTAssertNotNil(report)
//			XCTAssert(report!.count() == nutrients.count)
//			XCTAssert(report!.contains(Nutrient.Calcium))
//			XCTAssert(report!.contains(Nutrient.Protein))
//			//TODO test repoort!.getFoodItemNutrient = calcium, protein
//			expectation.fulfill()
//		}
//
//		Database5.requestNutrientReport(tunaFoodId, nutrients, completion)
//		wait(for: [expectation], timeout: 15.0)
//	}

//	func testNutrientReportNil() {
//		let tunaFoodId = 15117
//		let nutrients = [Nutrient]()
//		let expectation = XCTestExpectation(description: "Test Nutrient Report should be nil")
//
//		let printNutrientReport: (NutrientReport?) -> Void = { (report: NutrientReport?) -> Void in
//			XCTAssertNil(report)
//			expectation.fulfill()
//		}
//
//		Database5.requestNutrientReport(tunaFoodId, nutrients, printNutrientReport)
//		wait(for: [expectation], timeout: 15.0)
//	}
	


	//MARK: Performance
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

/*

typeMismatch(Swift.String, Swift.DecodingError.Context(codingPath: [NutritionTracker.FoodReportV2.Result.(CodingKeys in _832523B8D6338DACE4DCA4ED45323B37).foods, Foundation.(_JSONKey in _12768CA107A31EF2DCE034FD75B541C9)(stringValue: "Index 1", intValue: Optional(1)), NutritionTracker.FoodReportV2.JFoodContainer.(CodingKeys in _832523B8D6338DACE4DCA4ED45323B37).food, NutritionTracker.FoodReportV2.JFood.(CodingKeys in _832523B8D6338DACE4DCA4ED45323B37).nutrients, Foundation.(_JSONKey in _12768CA107A31EF2DCE034FD75B541C9)(stringValue: "Index 0", intValue: Optional(0)), NutritionTracker.FoodReportV2.JNutrient.(CodingKeys in _832523B8D6338DACE4DCA4ED45323B37).value], debugDescription: "Expected to decode String but found a number instead.", underlyingError: nil))
report failed


*/
