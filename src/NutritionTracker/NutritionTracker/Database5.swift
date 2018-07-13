//
//  Database5.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//
// 	TODO: test handling of nil values & failures.

import Foundation


class Database5 {
	// MARK: - Singleton
	static let sharedInstance = Database5()
	private init() {}
	private let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
	
	
	// MARK: - Completion types
	//TODO consider returning Bool for success, instead of Void
	typealias NutrientReportCompletion = (_ report: NutrientReport?) -> Void
	typealias FoodReportCompletionV1 = (_ report: FoodReportV1?) -> Void
	typealias FoodReportCompletionV2 = (_ report: FoodReportV2?) -> Void
	typealias SearchCompletion = (_ data: Data?) -> Void
	typealias SearchResultCompletion = (_ foodItems: [FoodItem]) -> Void
	typealias FoodItemNutrientCompletion = (_ foodItemNutrient: FoodItemNutrient) -> Void
	typealias AmountPerCompletion = (_ amountPer: AmountPer) -> Void
	typealias FoodItemsCompletion = (_ foodItems: [FoodItem]) -> Void
	
	// MARK: - USDA Queries


	// Request a food nutrient report from the usda database.
	// NOTE: must provide at least 1 nutrient.
	public func requestNutrientReport(_ foodId: Int, _ nutrientList: [Nutrient], _ completion: @escaping NutrientReportCompletion, _ debug: Bool = false) {
		if (nutrientList.count == 0) { completion(nil) }

		//add each nutrient id to query
		var urlStr = "https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=\(KEY)&ndbno=\(foodId)"
		for nut in nutrientList { urlStr.append("&nutrients=\(nut.getId())") }
		
		//request data from database
		guard let urlRequest = makeUrlRequestFromString(urlStr) else { print("error creating urlRequest:\(urlStr)"); return}
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data else { print("error fetching data."); return }
			if debug { self.printJsonData(data) }
			
			//parse json data into FoodNutrientReport & return it via completion callback
			//if let report = self.jsonDataToNutrientReport(foodId, data) {
			if let report = NutrientReport.fromJsonData(foodId, data) {
				completion(report)
			} else {
				if debug { print("report failed.") }
				completion(nil)
			}
		}
		task.resume()
	}
	
	//NOTE meal must contain at least 1 food item.
	public func requestFoodReportV2(_ meal: Meal, _ completion: @escaping FoodReportCompletionV2, _ debug: Bool = false) {
		requestFoodReportV2(Array(meal.getFoodItems()), completion, debug)
	}
	public func requestFoodReportV2(_ foodItems: [FoodItem], _ completion: @escaping FoodReportCompletionV2, _ debug: Bool = false) {
		if (foodItems.count == 0) {
			if debug { print("Databse5.requestFoodReportV2: 0 fooditems received.") }
			completion(nil)
			return
		}
		if debug {print("Database5.FoodReportV2 request received.")}

		//for each food item in meal, add foodId to the query
		var urlStr = "https://api.nal.usda.gov/ndb/V2/reports?&type=f&format=json&api_key=\(KEY)"
		for foodItem in foodItems {
			urlStr.append("&ndbno=\(foodItem.getFoodId())")
		}
		
		guard let urlRequest = makeUrlRequestFromString(urlStr) else {
			if debug{ print("urlRequest failed") }
			completion(nil)
			return
		}
		
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data else {
				print("error fetching data.")
				completion(nil)
				return
			}
			if debug { self.printJsonData(data) }
			
			if let report = FoodReportV2.fromJsonData(data, debug) {
				if debug { print("report succeeded.") }
				completion(report)
			} else {
				if debug { print("report failed") }
				completion(nil)
			}
		}
		task.resume()
	}
	
	//search for food items, return an array of FoodItems on completion.
	public func search(_ searchTerms: String, _ completion: @escaping SearchResultCompletion) {
		let sort = "n"      // n: sort by name, r: search by relevence
		let max = "50"      // max items to return
		
		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(searchTerms)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
		//makeSearchQuery(queryURL, completion)
		guard let requestUrl = URL(string: queryURL) else {return}
		let request = URLRequest(url:requestUrl)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else {
				print("makeQuery: error loading data")
				completion([FoodItem]())
				return
			}
			let foodItems = Database5.jsonSearchToFoodItems(data)
			completion(foodItems)
		}
		task.resume()
	}
	
	
	// MARK: Specific Queries

	
	public func getFoodItemNutrientOf(_ foodId: Int, nutrient: Nutrient, _ completion: @escaping FoodItemNutrientCompletion) {
		
	}
	
	//return the amount of a specific nutrient in a specific food.
//	public func getAmountPer(_ nutrient: Nutrient, _ foodId: Int, _ completion: @escaping AmountPerCompletion) {
//		let ndbno = foodId
//		//query url for getting the amount of a specific nutrient in the food.
//		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&ndbno=\(ndbno)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
//	}
	
	//Return a list containing the nutrients in a given food.
//	public func getNutrients(foodId: Int, _ completion: @escaping ) { //-> [FoodItemNutrient]
//		//var nutrients = [FoodItemNutrient]()
//		let ndbno = foodId
//		// query url for getting nutrients in a food
//		//TODO query needs to be a "report", not a "search"
//		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&ndbno=\(ndbno)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
//	}

	//Return a list of FoodItem's corresponding to the given FoodGroup.
//	public func getFoodItemsFrom(_ foodGroupId: String, _ completion: @escaping FoodItemsCompletion) {
//		let fg = foodGroupId
//		// query url for getting foods in a FoodGroup (using the food group id)
//		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&fg=\(fg)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
//	}
	
	//MARK: JSON
	//Takes json data, and returns an array of FoodItem's (search results)
	static func jsonSearchToFoodItems(_ jsonData: Data) -> [FoodItem] {
		var foodItems = [FoodItem]()
		
		// Structs for containing json variables
		struct Database: Decodable {
			let list: List?
		}
		
		struct List: Decodable {
			let item: [Items?]?
		}
		
		struct Items: Decodable {
			let name: String?
			let group: String? // food group
			let ndbno: String?
		}
		do {
			let data = try JSONDecoder().decode(Database.self, from: jsonData)
			
			//pass name and id to FoodItem array
			guard let dataList = data.list else { return foodItems }
			guard let dataListItem = dataList.item else { return foodItems }
			for i in dataListItem {
				let temp = FoodItem(Int(i!.ndbno!), i!.name!)
				foodItems.append(temp)
			}
		} catch let jsonErr {
			print("Error serializing Json:", jsonErr)
		}
		
		return foodItems
	}
	
	
	//MARK: Helpers
	private func makeUrlRequestFromString(_ urlStr: String) -> URLRequest? {
		guard let url = URL(string: urlStr) else {
			print("error creating url: \(urlStr)"); return nil
		}
		return URLRequest(url: url)
	}
	
	private func printJsonData(_ data: Data) {
		print("*")
		print(String(data: data, encoding:String.Encoding.ascii)!)
		print("*")
	}
}
