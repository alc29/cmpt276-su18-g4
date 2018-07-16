//
//  Database5.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Class for interacting with the usda database via browser queries.
//
// 	TODO: test handling of nil values & failures.

import Foundation
import RealmSwift

class Database5 {
	private init() {}
	private static let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
	
	
	// MARK: - Completion types
	//TODO consider returning Bool for success, instead of Void
	typealias FoodReportCompletionV1 = (_ report: FoodReportV1?) -> Void
	typealias SearchResultCompletion = (_ foodItems: [FoodItem]) -> Void
	typealias FoodItemNutrientCompletion = (_ foodItemNutrient: FoodItemNutrient) -> Void
	typealias AmountPerCompletion = (_ amountPer: AmountPer) -> Void
	typealias FoodItemsCompletion = (_ foodItems: [FoodItem]) -> Void
	typealias MealCompletion = (_ meal: Meal?) -> Void

	// Request a food reportV1, whcih returns & caches nutrient info about 1 specific food.
	static func requestFoodReportV1(_ foodItem: FoodItem, _ completion: @escaping FoodReportCompletionV1, _ debug: Bool = false) {
		do {
			
			//let foodId = foodItem.getFoodId()
			//prefix foodId with zeroes: string representing ndbno must be at least 5 digits.
			let foodIdStr = Util.getProperFoodIdStr(foodItem.getFoodId())
			
			let urlStr = "https://api.nal.usda.gov/ndb/reports/?ndbno=\(foodIdStr)&type=f&format=json&api_key=\(KEY)"
			guard let urlRequest = makeUrlRequestFromString(urlStr) else {
				if debug { print("url request failed: \(urlStr)") }
				completion(nil)
				return
			}
			
			let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
				guard let data = data else {
					print("error fetching data")
					completion(nil)
					return
				}
				//if debug { self.printJsonData(data) }
				
				if let report = FoodReportV1.cacheFromJsonData(data, debug) {
					if debug { print("foodreport v1 completion successful.") }
					completion(report)
				} else {
					if debug { print("fromJsonData returned nil.") }
					completion(nil)
				}
			}
			task.resume()
			
		} catch let error {
			print("requestFoodReportV1 error caught:")
			print(error)
		}
		
		
	} //end request


	
	// Search for food items based on a string, return an array of FoodItems on completion.
	static func search(_ searchTerms: String, _ completion: @escaping SearchResultCompletion) {
		let sort = "n" // n: sort by name, r: search by relevence
		let max = "50" // max items to return
		
		let urlStr = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(searchTerms)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
		guard let requestUrl = URL(string: urlStr) else {return}
		let request = URLRequest(url:requestUrl)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else {
				print("Database5.search(): error loading data")
				completion([FoodItem]())
				return
			}
			let foodItems = Database5.jsonSearchToFoodItems(data)
			completion(foodItems)
		}
		task.resume()
	}
	
	// Returns an array of food items from a given food group.
	//TODO refactor; similar to search()
	//TODO consider passing food group instead
	static func foodGroupSearch(_ foodGroupId: String, _ completion: @escaping FoodItemsCompletion, _ max: Int = 50) {

		//TODO if not valid food group id, complete(nil)
		var urlStr = "https://api.nal.usda.gov/ndb/search/?format=json&fg=\(foodGroupId)&max=\(max)&offset=0&api_key=\(KEY)"
		guard let requestUrl = URL(string: urlStr) else {return}
		let request = URLRequest(url: requestUrl)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else {
				print("Database5.foodGroupSearch(): error loading data")
				completion([FoodItem]())
				return
			}
			let foodItems = Database5.jsonSearchToFoodItems(data)
			completion(foodItems)
		}
		task.resume()
		
		//TODO convert json data to an array of food items
		
		//completion([FoodItem]()) //empty
	}
	
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
			print("Database5.jsonSearchToFoodItems: Error serializing Json:", jsonErr)
		}
		
		return foodItems
	}
	
	//TODO 2nd try
	static func getCachedFoodItem(_ foodItemId: Int) -> CachedFoodItem? {
		let realm = try! Realm()
		let results = realm.objects(CachedFoodItem.self)
		for item in results {
			if item.getFoodId() == foodItemId {
				return item
			}
		}
		return nil
	}
	
	private static func makeUrlRequestFromString(_ urlStr: String) -> URLRequest? {
		guard let url = URL(string: urlStr) else {
			print("error creating url: \(urlStr)"); return nil
		}
		return URLRequest(url: url)
	}
	
//save a food item that also contains nutrient information.
//	static func cacheFoodItem(_ cachedFoodItem: CachedFoodItem) {
//		DispatchQueue.main.async {
//			let realm = try! Realm()
//			try! realm.write {
//				realm.add(cachedFoodItem)
//			}
//		}
//	}

	
	// MARK: Method graveyard
	
// Request a food nutrient report from the usda database.
// NOTE: must provide at least 1 nutrient.
//	static func requestNutrientReport(_ foodId: Int, _ nutrientList: [Nutrient], _ completion: @escaping NutrientReportCompletion, _ debug: Bool = false) {
//		if (nutrientList.count == 0) { completion(nil) }
//
//		//add each nutrient id to query
//		var urlStr = "https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=\(KEY)&ndbno=\(foodId)"
//		for nut in nutrientList { urlStr.append("&nutrients=\(nut.getId())") }
//
//		//request data from database
//		guard let urlRequest = makeUrlRequestFromString(urlStr) else { print("error creating urlRequest:\(urlStr)"); return}
//		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//			guard let data = data else { print("error fetching data."); return }
//			if debug { Util.printJsonData(data) }
//
//			//parse json data into FoodNutrientReport & return it via completion callback
//			if let report = NutrientReport.fromJsonData(foodId, data, debug) {
//				completion(report)
//			} else {
//				if debug { print("report failed.") }
//				completion(nil)
//			}
//		}
//		task.resume()
//	}


//TODO consider renaming to "fetch"
//NOTE meal must contain at least 1 food item.
//	static func requestFoodReportV2(_ meal: Meal, _ completion: @escaping FoodReportCompletionV2, _ debug: Bool = false) {
//		requestFoodReportV2(Array(meal.getFoodItems()), completion, debug)
//	}
//	static func requestFoodReportV2(_ foodItems: [FoodItem], _ completion: @escaping FoodReportCompletionV2, _ debug: Bool = false) {
//		if debug {print("Database5.FoodReportV2 request received.")}
//		if (foodItems.count == 0) {
//			if debug { print("Databse5.requestFoodReportV2: 0 fooditems received.") }
//			completion(nil)
//			return
//		}
//
//		//for each food item in meal, add foodId to the query
//		var urlStr = "https://api.nal.usda.gov/ndb/V2/reports?&type=f&format=json&api_key=\(KEY)"
//		for foodItem in foodItems {
//			urlStr.append("&ndbno=\(foodItem.getFoodId())")
//		}
//
//		guard let urlRequest = makeUrlRequestFromString(urlStr) else {
//			if debug{ print("urlRequest failed") }
//			completion(nil)
//			return
//		}
//
//		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//			guard let data = data else {
//				print("error fetching data.")
//				completion(nil)
//				return
//			}
//			if debug { self.printJsonData(data) }
//
//			if let report = FoodReportV2.fromJsonData(data, debug) {
//				if debug { print("report succeeded.") }
//				completion(report)
//			} else {
//				if debug { print("report failed") }
//				completion(nil)
//			}
//		}
//		task.resume()
//	}
	
}
