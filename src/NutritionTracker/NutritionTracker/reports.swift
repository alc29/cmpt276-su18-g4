//
//  reports.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Contains the following classes:
//	NutrientReport, FoodReportV1, FoodReportV2

import Foundation
import RealmSwift

/**
//Nutrient information about a food
Reference:
https://ndb.nal.usda.gov/ndb/doc/apilist/API-NUTRIENT-REPORT.md
*/
class NutrientReport {
	
	//MARK: Json structs
	struct Result: Decodable {
		let report: Report?
	}
	struct Report: Decodable {
		let foods: [JFood]?
	}
	struct JFood: Decodable {
		let ndbno: String?
		let name: String?
		let weight: Float?
		let measure: String? //household measure represented by the nutrient value element
		let nutrients: [JNutrient]?
	}
	struct JNutrient: Decodable {
		let nutrient_id: String?
		let nutrient: String?
		let unit: String? //unit in which the nutrient value is expressed
		let value: String? //value of the nutrient for this food
		let gm: Float? //the 100 gram equivalent value for the nutrient
	}
	
	//MARK: Properties
	var foodId: Int = -1
	var foodItemNutrients = [FoodItemNutrient]()
	//let foodItemNutrients = List<FoodItemNutrient>()
	
	convenience init (_ foodId: Int, _ nutrients: [FoodItemNutrient]) {
		self.init()
		self.foodId = foodId
		self.foodItemNutrients = nutrients
	}
	
	// MARK: public methods
	
	func contains(_ nutrient: Nutrient) -> Bool {
		return foodItemNutrients.contains { n in nutrient.getId() == n.getNutrientId() }
	}
	
	func contains(_ nutrient: FoodItemNutrient) -> Bool {
		return foodItemNutrients.contains { n in nutrient.getName() == n.getName() }
	}
	
	func count() -> Int { return foodItemNutrients.count }
	func getFoodItemNutrients() -> [FoodItemNutrient] { return Array(foodItemNutrients) }
	
	//TODO use dictionary instead of for loop & test
	func getFoodItemNutrient(_ nutrient: Nutrient) -> FoodItemNutrient? {
		if !contains(nutrient) {
			return nil
		}
		for n in foodItemNutrients {
			if n.getNutrient().getId() == nutrient.getId() {
				return n
			}
		}
		return nil
	}
	
	//MARK: json Parsing
	
	//Factory method using json data
	static func fromJsonData(_ foodId: Int, _ jsonData: Data, _ debug: Bool = false) -> NutrientReport? {
		
		guard let result = try? JSONDecoder().decode(NutrientReport.Result.self, from: jsonData) else {print("json: result failed"); return nil }
		guard let report = result.report else { if debug {print("json: result.report failed")}; return nil }
		guard let foods = report.foods else { if debug {print("json: result.foods failed")}; return nil }
		guard let food = foods.first else { if debug{print("json: food.first failed")}; return nil }
		guard let jNutrients = food.nutrients else { if debug{print("json: food.nutrients failed")}; return nil }

		var nutrients = [FoodItemNutrient]()
		for jNut in jNutrients {
			if debug {print("nut: \(String(describing: jNut.nutrient))")}
			let foodItemNutrient = NutrientReport.jNutrientToFoodItemNutrient(jNut)
			nutrients.append(foodItemNutrient)
		}
		return NutrientReport(foodId, nutrients)
	}
	
	//TODO
	private static func jNutrientToFoodItemNutrient(_ jNutrient: JNutrient) -> FoodItemNutrient {
		let nutrient = NutrientReport.jNutrientToNutrient(Int(jNutrient.nutrient_id!)!)
		let amountPer = AmountPer() //TODO
		return FoodItemNutrient(nutrient, amountPer)
	}
	
	private static func jNutrientToNutrient(_ id: Int) -> Nutrient {
		return Nutrient.get(id: id)
	}
}



/**

Reference: https://ndb.nal.usda.gov/ndb/doc/apilist/API-FOOD-REPORTV2.md
*/
//class FoodReportV2 : Object {
//	struct Result: Decodable {
//		let foods: [JFoodContainer?]?
//		let count: Int?
//		let notfound: Int?
//		let api: Int?
//
//		struct JFoodContainer: Decodable {
//			let food: JFood?
//		}
//
//		struct JFood: Decodable {
//			let sr: String?
//			let type: String?
//			let desc: JDescription?
//			let ing: Ing?
//			let nutrients: [JNutrient?]?
//
//			struct JDescription: Decodable {
//				let ndbno: String?
//				let name: String?
//				let sd: String? //short description
//			}
//			struct JNutrient: Decodable {
//				let nutrient_id: String?
//				let name: String?
//				let derivation: String?
//				let group: String?
//				let unit: String? //measurement unit
//				let value: String? //problematic
//				let measures: [JMeasure?]?
//
//				struct JMeasure: Decodable {
//					let label: String?
//					let eqv: Int?
//					let eunit: String?
//					let qty: Int?
//					let value: String? //gram equivalent value of the measure
//				}
//			}
//			struct Ing: Decodable {
//				let desc: String?
//				let upd: String?
//			}
//		}
//	}
//	struct LegacyResult: Decodable {
//		let foods: [JFoodContainer?]?
//		let count: Int?
//		let notfound: Int?
//		let api: Int?
//
//		struct JFoodContainer: Decodable {
//			let food: JFood?
//		}
//
//		struct JFood: Decodable {
//			let sr: String?
//			let type: String?
//			let desc: JDescription?
//			let ing: Ing?
//			let nutrients: [JNutrient?]?
//
//			struct JDescription: Decodable {
//				let ndbno: String?
//				let name: String?
//				let sd: String? //short description
//			}
//			struct JNutrient: Decodable {
//				let nutrient_id: Int?
//				let name: String?
//				let derivation: String?
//				let group: String?
//				let unit: String? //measurement unit
//				let value: Float? //
//				let measures: [JMeasure?]?
//
//				struct JMeasure: Decodable {
//					let label: String?
//					let eqv: Int?
//					let eunit: String?
//					let qty: Int?
//					let value: Float? //gram equivalent value of the measure
//				}
//			}
//			struct Ing: Decodable {
//				let desc: String?
//				let upd: String?
//			}
//		}
//	}
//
//	//MARK: Properties
//	//TODO convert all jFoods in Result into FoodItems.
//	var jFoods = [Result.JFood]()
//	var result: Result?
//	//private var foodNutrientItems = List<FoodNutrientItem>()
//	//var foodItemsToCache = List<CachedFoodItem>()
//
//	// MARK: Methods
//	func addJFood(_ jFood: Result.JFood) {
//		jFoods.append(jFood)
//	}
//	func count() -> Int {
//		return jFoods.count
//	}
//
//	static func jNutrientToFoodItemNutrient(_ jNutrient: FoodReportV2.Result.JFood.JNutrient) -> FoodItemNutrient? {
//		guard let nutrient_id = jNutrient.nutrient_id else { print("no nutrient_id found."); return nil }
//
//		let nutrientId = Int(nutrient_id) //string to int
//		let nutrient = Nutrient.get(id: nutrientId!)
//		//let baseAmount = Amount(Float(jNutrient.value!)!, Unit.get(jNutrient.unit!)!) //TODO
//		let baseAmount = Amount()
//		let ratioAmount = Amount(100.0, Unit.Gram) //TODO
//		let amountPer = AmountPer(amount: baseAmount, per: ratioAmount)
//
//		return FoodItemNutrient(nutrient, amountPer)
//	}
//
//	static func fromJsonData(_ jsonData: Data, _ debug: Bool = false) -> FoodReportV2? {
//		do {
//			let result = try JSONDecoder().decode(FoodReportV2.Result.self, from: jsonData)
//			guard let foods = result.foods else { if debug{print("result.foods failed")}; return nil}
//			let foodReportV2 = FoodReportV2()
//			foodReportV2.result = result
//
//			for foodContainer in foods { // for each food item requested in the report
//				if let foodContainer = foodContainer, let jFood = foodContainer.food {
//					foodReportV2.addJFood(jFood)
//
//					// get nutrients from jFood, convert to FoodItemNutrient; add to food item
//					if let desc = jFood.desc, let ndbno = desc.ndbno, let foodId = Int(ndbno), let foodName = desc.name {
//						//let foodItem = FoodItem(foodId, foodName)
//						let cachedFoodItem = CachedFoodItem(foodId)
//
//						if let jNutrients  = jFood.nutrients {
//							for jNutrient in jNutrients {
//								guard let jNutrient = jNutrient, let nutrient_id = jNutrient.nutrient_id else { continue }
//
//								let nutrientId = Int(nutrient_id)
//								let nutrient = Nutrient.get(id: nutrientId!)
//
//								let amount = Amount() //TODO
//								let per = Amount(100, Unit.Gram) //TODO
//								let amountPer = AmountPer(amount: amount, per: per)
//
//								let foodItemNutrient = FoodItemNutrient(nutrient, amountPer)
//								//foodItem.addNutrient(foodItemNutrient)
//								//add foodItemNutrient to cache
//								cachedFoodItem.addFoodItemNutrient(foodItemNutrient)
//							}
//						}
//						Database5.cacheFoodItem(cachedFoodItem)
//					}
//				}
//			}
//
//			return foodReportV2
//
//		} catch let error {
//			print("trying legacy decode")
//		}
//
//		//Try decoding legacy
//		do {
//			let result = try JSONDecoder().decode(FoodReportV2.Result.self, from: jsonData)
//			guard let foods = result.foods else { if debug{print("result.foods failed")}; return nil}
//			let foodReportV2 = FoodReportV2()
//			foodReportV2.result = result
//
//			for foodContainer in foods { // for each food item requested in the report
//				if let foodContainer = foodContainer, let jFood = foodContainer.food {
//					foodReportV2.addJFood(jFood)
//
//					// get nutrients from jFood, convert to FoodItemNutrient; add to food item
//					if let desc = jFood.desc, let ndbno = desc.ndbno, let foodId = Int(ndbno), let foodName = desc.name {
//						//let foodItem = FoodItem(foodId, foodName)
//						let cachedFoodItem = CachedFoodItem(foodId)
//
//						if let jNutrients  = jFood.nutrients {
//							for jNutrient in jNutrients {
//								guard let jNutrient = jNutrient, let nutrient_id = jNutrient.nutrient_id else { continue }
//
//								let nutrientId = Int(nutrient_id)
//								let nutrient = Nutrient.get(id: nutrientId!)
//
//								let amount = Amount() //TODO
//								let per = Amount(100, Unit.Gram) //TODO
//								let amountPer = AmountPer(amount: amount, per: per)
//
//								let foodItemNutrient = FoodItemNutrient(nutrient, amountPer)
//								//foodItem.addNutrient(foodItemNutrient)
//								//add foodItemNutrient to cache
//								cachedFoodItem.addFoodItemNutrient(foodItemNutrient)
//							}
//						}
//						Database5.cacheFoodItem(cachedFoodItem)
//					}
//				}
//			}
//
//			return foodReportV2
//		} catch let error {
//			print(error)
//		}
//
//		return nil
//	}
//}

