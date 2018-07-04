////
////  DatabaseWrapper.swift
////  NutritionTracker
////
////  Created by alc29 on 2018-06-30.
////  Copyright � 2018 alc29. All rights reserved.
////
////	Class containing database logic & methods. Used by view controllers for
////	querying & fetching data from the USDA database via their REST API.
////
//// AKN:
////	https://ndb.nal.usda.gov/ndb/doc/index
////	https://krakendev.io/blog/the-right-way-to-write-a-singleton
////	https://code.bradymower.com/swift-3-apis-network-requests-json-getting-the-data-4aaae8a5efc0
//import Foundation
//import RealmSwift
//
//
//class DatabaseWrapper {
//	//MARK: Properties
//	static let sharedInstance = DatabaseWrapper()
//	private init() {}
//	private let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
//	let sort = "n"      // n: sort by name, r: search by relevence
//	let max = "25"      // max items to return
//
//	typealias AmountPerCompletion = (_ amountper: AmountPer) -> Void
////	typealias JsonDataCompletion = (_ jsonData: Data) -> Void
//	typealias StringCompletion = (_ string: String) -> Void
//
//	public func getNutrientsAsync(_ inStr: String, _ completionCallback: @escaping StringCompletion) {
//		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports/?ndbno=01009&format=json&api_key=\(KEY)"
//		guard let requestUrl = URL(string: queryURL) else {return}
//		let url = URLRequest(url:requestUrl)
//		//let task = URLSession.shared.dataTask(with: request, completionHandler: @escaping
//
//		URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
//			print("calling completionCallback")
//			completionCallback(inStr) // Here's where we call the completion handler with the result once we have it
//		}).resume()
//	}
//
//
//	// MARK: Public functions
//	//return a list of search results as FoodItem's
//	public func search(_ searchTerms: String) -> [FoodItem] {
//		let foodItems = [FoodItem]()
////		let q = searchTerms
////		//TODO finish query url for general search term.
////		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(q)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
////		let jsonData = makeQuery(queryURL)
////		if jsonData != nil {
////			return jsonToFoodItems(jsonData!)
////		}
//		return foodItems
//	}
//
//	//Return a list of FoodItem's corresponding to the given FoodGroup.
//	public func getFoodItemsFrom(foodGroupId: String) -> [FoodItem] {
//		let fg = foodGroupId
//		// query url for getting foods in a FoodGroup (using the food group id)
////		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&fg=\(fg)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
////		let jsonData = makeQuery(queryURL)
////		if jsonData != nil {
////			return jsonToFoodItems(jsonData!)
////		}
//
//		return [FoodItem]() //return empty array if unsuccessful.
//	}
//
//
//
//	//return the amount of a specific nutrient in a specific food.
//	func getAmountPerOf(_ nutrient: Nutrient, _ foodId: Int, _ completion: @escaping JsonDataCompletion) {
//		let ndbno = foodId
//		// query url for getting the amount of a specific nutrient in the food.
//		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&ndbno=\(ndbno)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
//		makeQuery(queryURL, completion)
////		let jsonData = makeQuery(queryURL, completion)
////		if jsonData != nil {
////			return jsonToAmountPer(jsonData!, nutrient: nutrient)
////		}
////		return nil
//	}
//
//
//
//	//Return a list containing the amount of nutrients in a given food.
//	func getNutrients(foodId: Int, _ completion: @escaping JsonDataCompletion) {
//		// query url for getting nutrients in a food
////		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
////		let jsonData = makeQuery(queryURL, completion)
////		if jsonData != nil {
////			return jsonToNutrients(jsonData!)
////		}
//	}
//
//
//	// MARK: URL Queries
//	//Submits a query request to the database, and returns the json Data
//	private func makeQuery(_ queryURL: String, _ completion: @escaping JsonDataCompletion) {
//
//		var returnJsonData: Data?
//		guard let requestUrl = URL(string: queryURL) else {return}
//		let request = URLRequest(url:requestUrl)
//		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//			if error == nil, let jsonData = data {
//				completion(jsonData)
//			}
//		}
//		task.resume()
//	}
//
//	// MARK: JSON Conversion
//	//Takes json Data, and returns an array of Nutrient's.
//	private func jsonToNutrients(_ jsonData: Data) -> [FoodItemNutrient] {
//		var nutrients = [FoodItemNutrient]()
//		//TODO figure out proper structs:
//		/*
//		struct JDatabase: Decodable {
//		let foods: [JFood]?
//		}
//		struct JFood: Decodable {
//		let nutrients: Nutrient?
//		let item: []
//		}
//		struct JNutrient: Decodable {
//		let name: String?
//		let value: String?
//		}
//		*/
//
//		do {
//			//TODO parse json:
//			//let database = try JSONDecoder().decode(JDatabase.self, from: jsonData)
//			//populate or assign nutrients array
//		} catch let jsonErr {
//			print("Error serializing Json:", jsonErr)
//		}
//		return nutrients
//	}
//
//
//	//Takes json Data, and returns an AmountPer (amount of a specific nutrient contained in a specific food.)
//	private func jsonToAmountPer(_ jsonData: Data, nutrient: Nutrient) -> AmountPer {
//		//structs for json decoding
//		struct Database: Decodable {
//			let foods: [Food]?
//		}
//		struct Food: Decodable {
//			let food: NutrientStruct?
//		}
//		struct NutrientStruct: Decodable {
//			let nutrients: [Nutrients]?
//		}
//		struct Nutrients: Decodable {
//			let nutrient_id: Int?
//			let name: String?
//			let unit: String?
//			let value: Float?
//		}
//
//		// variables
//		var value = Float()
//		var nutrientVal = AmountPer()
//
//		do {
//			//TODO parse json:
//			let data = try JSONDecoder().decode(Database.self, from: jsonData)
//
//			for i in data.foods!.first!.food!.nutrients! {
//				if (i.name == nutrient.name) {
//					value = i.value!
//				}
//				nutrientVal = AmountPer(amount: Amount(value, Unit.Gram), per: Amount(100, Unit.Gram))
//			}
//
//		} catch let jsonErr {
//			print("Error serializing Json:", jsonErr)
//		}
//
//		return nutrientVal //TODO remove placeholder
//	}
//
//
//
//	//Takes json data, and returns an array of FoodItem's (search results)
//	private func jsonToFoodItems(_ jsonData: Data) -> [FoodItem] {
//		var foodItems = [FoodItem]()
//
//		// Structs for containing json variables
//		struct Database: Decodable {
//			let list: List?
//		}
//
//		struct List: Decodable {
//			let item: [Items]?
//		}
//
//		struct Items: Decodable {
//			let name: String?
//			let group: String? // food group
//			let ndbno: String?
//		}
//		do {
//			//TODO parse json:
//			let data = try JSONDecoder().decode(Database.self, from: jsonData)
//
//			//pass name and id to FoodItem array
//			for i in data.list!.item! {
//				let temp = FoodItem(Int(i.ndbno!), i.name!)
//				foodItems.append(temp)
//			}
//		} catch let jsonErr {
//			print("Error serializing Json:", jsonErr)
//		}
//
//
//		return foodItems
//	}
//}

