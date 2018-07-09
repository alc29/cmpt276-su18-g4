//
//  FoodNutrientReport.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Reference:
//	https://ndb.nal.usda.gov/ndb/doc/apilist/API-NUTRIENT-REPORT.md

import Foundation

//nutrient information about a food
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
	let foodId: Int
	var nutrients = [FoodItemNutrient]()
	
	// MARK: public methods
	init (_ foodId: Int) {
		self.foodId = foodId
	}

	func addNutrient(_ nutrient: FoodItemNutrient) {
		if !contains(nutrient) {
			nutrients.append(nutrient)
		}
	}
	
	func contains(_ nutrient: FoodItemNutrient) -> Bool {
		return nutrients.contains { n in nutrient.getName() == n.getName() }
	}
	
	func count() -> Int { return nutrients.count }
	func getNutrients() -> [FoodItemNutrient] { return nutrients }

	
	//MARK: json Parsing
	
	//Factory method using json data
	static func fromJsonData(_ foodId: Int, _ jsonData: Data) -> NutrientReport? {
		
		guard let result = try? JSONDecoder().decode(NutrientReport.Result.self, from: jsonData) else {print("json: result failed"); return nil }
		guard let report = result.report else {print("json: result.report failed"); return nil }
		guard let foods = report.foods else { print("json: result.foods failed"); return nil }
		guard let food = foods.first else { print("json: food.first failed"); return nil }
		guard let jNutrients = food.nutrients else { print("json: food.nutrients failed"); return nil }

		let nutrientReport = NutrientReport(foodId)
		for jNut in jNutrients {
			print("nut: \(String(describing: jNut.nutrient))")
			let foodItemNutrient = NutrientReport.jNutrientToFoodItemNutrient(jNut)
			nutrientReport.addNutrient(foodItemNutrient)
		}
		return nutrientReport
	}
	
	private static func jNutrientToFoodItemNutrient(_ jNutrient: JNutrient) -> FoodItemNutrient {
		let nutrient = NutrientReport.jNutrientToNutrient(Int(jNutrient.nutrient_id!)!)
		let amountPer = AmountPer() //TODO
		return FoodItemNutrient(nutrient, amountPer)
	}
	
	private static func jNutrientToNutrient(_ id: Int) -> Nutrient {
		return Nutrient.get(id: id)
	}
}

class FoodReportV1 {
	struct Report {
		
	}
}
class FoodReportV2 {
	
}
