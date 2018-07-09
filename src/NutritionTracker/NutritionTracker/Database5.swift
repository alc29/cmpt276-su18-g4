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
	//typealias DataCompletion = (_ data: Data) -> Void
	typealias NutrientReportCompletion = (_ report: NutrientReport?) -> Void
	typealias FoodReportCompletionV1 = (_ report: FoodReportV1) -> Void
	//typealias FoodReportCompletionV2 = (_ report: FoodReportV2) -> Void
	
	
	// MARK: - Requests
	
	// Request a food nutrient report from the usda database.
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
	
	
//	public func requestFoodReportV2(_ meal: Meal, _ completion: FoodNutrientReportV2) {
//	}
	
	
	//MARK: Helpers
	private func makeUrlRequestFromString(_ urlStr: String) -> URLRequest? {
		guard let url = URL(string: urlStr) else {
			print("error creating url: \(urlStr)"); return nil
		}
		return URLRequest(url: url)
	}
	
	private static func printJsonData(_ data: Data) {
		print(String(data: data, encoding:String.Encoding.ascii)!)
	}
}
