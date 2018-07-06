//
//  Database5.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

//struct report: Decodable {
//	let foods: [JFood]?
//}

struct JFood: Decodable {
	let ndbno: String?
	let name: String?
	let weight: String?
	let measure: String?
	let nutrients: [JNutrient]?
}

struct JNutrient: Decodable {
	let nutrient_id: String?
	let nutrient: String?
	let unit: String?
	let value: String?
	let gm: Float?
}


class Database5 {
	struct report: Decodable {
		let foods: [JFood]?
	}

	static let sharedInstance = Database5()
	private init() {}
	private let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
	private let testFoodIds = [15117, 11090] //raw bluefin tuna, raw broccoli
	
	//typealias AnyCompletion = (_ data: Any?) -> Void
	typealias DataCompletion = (_ data: Data) -> Void
	typealias FoodNutrientReportCompletion = (_ report: FoodNutrientReport) -> Void
	
	
//	func makeQuery(_ queryURL: String, _ completion: @escaping DataCompletion) {
//		guard let requestUrl = URL(string: queryURL) else {
//			print("error creating URL: \(queryURL)")
//			return
//		}
//		let request = URLRequest(url:requestUrl)
//		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//			guard let data = data else {
//				print("makeQuery: error loading data")
//				return
//			}
//
//			completion(data)
//		}
//		task.resume()
//	}
	
	// MARK: - Requests
	// for each food item in the meal, retrieve the amount of each nutrient
	//TODO remove foodItem:FoodItem param
	public func requestNutrientReport(_ foodId: Int, _ nutrients: [Nutrient], _ completion: @escaping FoodNutrientReportCompletion) {
		var nutrientIds = [Int]()
		for n in nutrients {
			nutrientIds.append(n.getId())
		}
		self.requestNutrientReport(foodId, nutrientIds, completion)
	}
	public func requestNutrientReport(_ foodId: Int, _ nutrientIds: [Int], _ completion: @escaping FoodNutrientReportCompletion) {
		var urlStr = "https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=\(KEY)&ndbno=\(foodId)"
	
		//add each nutrient id to query
		//for n in nutrients { urlStr.append("&\(n.getId())") }
		for id in nutrientIds { urlStr.append("&\(id)") }
		
		//request data from database
		guard let urlRequest = makeUrlRequestFromString(urlStr) else { print("error creating urlRequest:\(urlStr)"); return}
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data else { print("error fetching data."); return }
			//parse json data into FoodNutrientReport & return it via completion callback
			if let report = self.jsonDataToFoodNutrientReport(foodId, data) {
				completion(report)
			}
		}
		task.resume()
	}
	

	
	//MARK: JSON parsing
	
	//parse json & return report
	private func jsonDataToFoodNutrientReport(_ foodId: Int, _ jsonData: Data) -> FoodNutrientReport? {

		do {
			//TODO parse json:
			let reportResult = try JSONDecoder().decode(report.self, from: jsonData)
			
			let foodNutrientReport = FoodNutrientReport(foodId)
			//for
//			foodNutrientReport.addNutrient()
			
			return foodNutrientReport
			
		} catch let jsonErr {
			print("Error parsing json: ", jsonErr)
		}
		
		return nil
	}
	
//	func appendNutrientToReport(_ nutrient: FoodItemNutrient, _ report: FoodNutrientReport) {
//		report.addNutrient(nutrient)
//	}


//	func jsonToFoodItemNutrient() -> FoodItemNutrient? {
//		let nutrient = Nutrient.Test
//		let amountPer = AmountPer()
//		let foodItemNutrient = FoodItemNutrient(nutrient, amountPer)
////		return foodItemNutrient
//		return nil
//	}
	
	//MARK: Helpers
	private func makeUrlRequestFromString(_ urlStr: String) -> URLRequest? {
		guard let url = URL(string: urlStr) else {
			print("error creating url: \(urlStr)"); return nil
		}
		return URLRequest(url: url)
	}
}
