//
//  reports.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Contains the following classes:
//	NutrientReport, FoodReportV1, FoodReportV2
//	TODO: other TODOs in this file

import Foundation
import RealmSwift

/**
//Nutrient information about a food
Reference:
https://ndb.nal.usda.gov/ndb/doc/apilist/API-NUTRIENT-REPORT.md
*/
class NutrientReport: Object {
	
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
	@objc dynamic var foodId: Int = -1
	//var foodItemNutrients = [FoodItemNutrient]()
	var foodItemNutrients = List<FoodItemNutrient>()
	
	// init
	convenience init (_ foodId: Int) {
		self.init()
		self.foodId = foodId
	}
	
	// MARK: public methods
	func addNutrient(_ nutrient: FoodItemNutrient) {
		if !contains(nutrient) {
			foodItemNutrients.append(nutrient)
		}
	}
	
//	func removeNutrient(_ nutrient: FoodItemNutrient) {
//	}
	
	//add or replace nutrients from the other report to this one.
	func update(_ report: NutrientReport) {
		for n in report.getFoodItemNutrients() {
			if !self.contains(n) {
				addNutrient(n)
			} else {
				//TODO remove & replace
			}
		}
	}
	
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

		let nutrientReport = NutrientReport(foodId)
		for jNut in jNutrients {
			if debug {print("nut: \(String(describing: jNut.nutrient))")}
			let foodItemNutrient = NutrientReport.jNutrientToFoodItemNutrient(jNut)
			nutrientReport.addNutrient(foodItemNutrient)
		}
		return nutrientReport
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
*/
class FoodReportV1 {
}




/**

Reference: https://ndb.nal.usda.gov/ndb/doc/apilist/API-FOOD-REPORTV2.md
*/
class FoodReportV2 {
	struct Result: Decodable {
		let foods: [JFood]?
		let count: Int?
		let notfound: Int?
		let api: Int?
	}

	struct JFood: Decodable {
		let desc: JDescription?
		let nutrients: [JNutrient]?
	}
	struct JDescription: Decodable {
		let ndbno: Int?
		let name: String?
		let sd: String? //short description
		let fg: String? //food group
	}

	struct JNutrient: Decodable {
		let nutrient_id: Int?
		let name: String?
		let group: String?
		let unit: String? //measurement unit
		let value: Float?
		let derivation: String?
		let dp: Int?
		let measures: [JMeasure]?
	}
	struct JMeasure: Decodable {
		let label: String?
		let equiv: Int?
		let eunit: String?
		let qty: Int?
		let value: Float? //gram equivalent value of the measure
	}
	
	//MARK: Properties
	//TODO
	private var jFoods = [JFood]()
	
	func addJFood(_ jFood: JFood) {
		jFoods.append(jFood)
	}
	func count() -> Int {
		return jFoods.count
	}
	
	// MARK: Functions
	static func fromJsonData(_ jsonData: Data, _ debug: Bool = false) -> FoodReportV2? {
		//TODO
		/*
		guard let result = try? JSONDecoder().decode(NutrientReport.Result.self, from: jsonData) else {print("json: result failed"); return nil }
		guard let report = result.report else { if debug {print("json: result.report failed")}; return nil }
		guard let foods = report.foods else { if debug {print("json: result.foods failed")}; return nil }
		guard let food = foods.first else { if debug{print("json: food.first failed")}; return nil }
		guard let jNutrients = food.nutrients else { if debug{print("json: food.nutrients failed")}; return nil }
		
		let nutrientReport = NutrientReport(foodId)
		for jNut in jNutrients {
		if debug {print("nut: \(String(describing: jNut.nutrient))")}
		let foodItemNutrient = NutrientReport.jNutrientToFoodItemNutrient(jNut)
		nutrientReport.addNutrient(foodItemNutrient)
		}
		return nutrientReport
		*/
		
		guard let result = try? JSONDecoder().decode(FoodReportV2.Result.self, from: jsonData) else { if debug {print("json: result failed")}; return nil }
		guard let foods = result.foods else { if debug {print("json: result.foods failed")}; return nil }
		let foodReportV2 = FoodReportV2()
		for jFood in foods {
			//let foodItem = jFoodToFoodItem(jFood) //TODO convert to FoodItem & list of FoodNutrientItems
			foodReportV2.addJFood(jFood)
		}
		//for each JFood in foods,
		return foodReportV2
	}
	
//	func jFoodToFoodItem(_ jFood: JFood) -> FoodItem {
//
//	}
	
}
