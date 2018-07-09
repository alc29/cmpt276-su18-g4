//
//  Database5.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

class FoodNutrientreportV2 {
	
}

class Database5 {
	
	static let sharedInstance = Database5()
	private init() {}
	private let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
	private let testFoodIds = [15117, 11090] //raw bluefin tuna, raw broccoli
	
	//typealias AnyCompletion = (_ data: Any?) -> Void
	typealias DataCompletion = (_ data: Data) -> Void
	//typealias FoodNutrientReportCompletion = (_ report: NutrientReport) -> Void
	typealias NutrientReportCompletion = (_ report: NutrientReport?) -> Void
	//typealias FoodNutrientReportCompletionV2 = (_ report: FoodNutrientReportV2) -> Void
	
	
	// MARK: - Requests
	// for each food item in the meal, retrieve the amount of each nutrient
	// NOTE: must provide at least 1 nutrient.
	public func requestNutrientReport(_ foodId: Int, _ nutrientList: [Nutrient], _ completion: @escaping NutrientReportCompletion) {
		var urlStr = "https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=\(KEY)&ndbno=\(foodId)"
	
		//add each nutrient id to query
		if (nutrientList.count == 0) { completion(nil) }
		for nut in nutrientList { urlStr.append("&nutrients=\(nut.getId())") }
		
		//request data from database
		guard let urlRequest = makeUrlRequestFromString(urlStr) else { print("error creating urlRequest:\(urlStr)"); return}
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data else { print("error fetching data."); return }
			self.printJsonData(data)
			
			//parse json data into FoodNutrientReport & return it via completion callback
			//if let report = self.jsonDataToNutrientReport(foodId, data) {
			if let report = NutrientReport.fromJsonData(foodId, data) {
				completion(report)
			} else {
				print("report failed.")
				completion(nil)
			}
		}
		task.resume()
	}
	
	
//	public func requestNutrientReportV2(_ meal: Meal, _ completion: FoodNutrientReportV2) {
//		var urlStr = ""
//	}
	
	//MARK: JSON parsing
	
	//parse json & return report
//	private func jsonDataToNutrientReport(_ foodId: Int, _ jsonData: Data) -> NutrientReport? {
//		guard let result = try? JSONDecoder().decode(FoodNutrientReport.Result.self, from: jsonData) else { print("json: result failed"); return nil }
//		guard let report = result.report else {print("json: result.report failed"); return nil }
//		guard let foods = report.foods else { print("json: result.foods failed"); return nil }
//		guard let food = foods.first else { print("json: food.first failed"); return nil }
//		if let jNutrients = food.nutrients {
//			let foodNutrientReport = FoodNutrientReport(foodId)
//			for nut in jNutrients {
//				print("nut: \(nut.nutrient)")
//				let nutrient = Nutrient.Test
//				let amount = AmountPer()
//				foodNutrientReport.addNutrient(FoodItemNutrient(nutrient, amount))
//			}
//			return foodNutrientReport
//		} else {
//			print("json: jNutrients failed")
//		}
//		return nil
//	}
	
	func jsonDataToFoodReportV2(_ data: Data) -> FoodReportV2? {
//		struct Result: Decodable {
//			let foods: [JFood]?
//			let count: Int?
//			let notfound: Int?
//			let api: Int?
//		}
//		struct Description: Decodable {
//			let ndbno: Int?
//		}
//
//		struct JFood: Decodable {
//			let desc: Description?
//			let nutrients: [JNutrient]?
//		}
//		struct JNutrient: Decodable {
//			let nutrient_id: Int? //TODO
//			let name: String?
//			let group: String?
//			let unit: String?
//			let value: Float?
//			let derivation: String?
//			let measures: [Measure]?
//		}
//		struct Measure: Decodable {
//			let label: String?
//			let equiv: Int?
//			let eunit: String?
//			let qty: Int?
//			let value: Float?
//		}
		
		//		guard let result = try? JSONDecoder().decode(Result.self, from: data) else { print("json: result failed"); return nil }
		//		guard let report = result.report else {print("json: result.report failed"); return nil }
		//		guard let foods = report.foods else { print("json: result.foods failed"); return nil }
		//		guard let food = foods.first else { print("json: food.first failed"); return nil }
		//		if let jNutrients = food.nutrients {
		//			let foodNutrientReport = FoodNutrientReport(foodId)
		//			for nut in jNutrients as [JNutrient] {
		//				let nutrient = Nutrient.Test
		//				let amount = AmountPer()
		//				foodNutrientReport.addNutrient(FoodItemNutrient(nutrient, amount))
		//			}
		//			return foodNutrientReport
		//		} else {
		//			print("json: jNutrients failed")
		//		}
		return nil
		
	}
	
	
	//MARK: Helpers
	private func makeUrlRequestFromString(_ urlStr: String) -> URLRequest? {
		guard let url = URL(string: urlStr) else {
			print("error creating url: \(urlStr)"); return nil
		}
		return URLRequest(url: url)
	}
	
	private func printJsonData(_ data: Data) {
		print(String(data: data, encoding:String.Encoding.ascii)!)
	}
}
