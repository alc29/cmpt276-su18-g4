////
////  DatabaseWrapper.swift
////  NutritionTracker
////
////  Created by alc29 on 2018-06-30.
////  Copyright � 2018 alc29. All rights reserved.
////
///**
//Fake database for testing, until integration with actual.
////TODO rename to Database
//AKN
//AKN: https://krakendev.io/blog/the-right-way-to-write-a-singleton
//https://code.bradymower.com/swift-3-apis-network-requests-json-getting-the-data-4aaae8a5efc0
//
//*/
//import Foundation
//import RealmSwift
//
//
//class DatabaseWrapper2 {
//	//MARK: Properties
//	static let sharedInstance = DatabaseWrapper2()
//	private init() {}
//	private let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
//	let sort = "n"      // n: sort by name, r: search by relevence
//	let max = "25"      // max items to return
//
//	// MARK: Public functions
//	//return a list of search results as FoodItem's
//	public func search(_ searchTerms: String) -> [FoodItem] {
//		// variables
//		var foodItems = [FoodItem]()
//		let q = searchTerms
//		//TODO finish query url for general search term.
//		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(q)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
//		let jsonData = makeQuery(queryURL)
//		if jsonData != nil {
//			return jsonToFoodItems(jsonData!)
//		}
//		return foodItems
//	}
//
//	//Return a list of FoodItem's corresponding to the given FoodGroup.
//	public func getFoodItemsFrom(foodGroupId: String) -> [FoodItem] {
//		//TODO finish query url for getting foods in a FoodGroup (using the food group id)
//		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
//		let jsonData = makeQuery(queryURL)
//		if jsonData != nil {
//			return jsonToFoodItems(jsonData!)
//		}
//
//		return [FoodItem]() //return empty array if unsuccessful.
//	}
//
//	//return the amount of a specific nutrient in a specific food.
//	public func getAmountPerOf(_ nutrient: Nutrient, foodId: Int) -> AmountPer? {
//		//TODO finish query url for getting the amount of a specific nutrient in the food.
//		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
//		let jsonData = makeQuery(queryURL)
//		if jsonData != nil {
//			return jsonToAmountPer(jsonData!)
//		}
//		return nil
//	}
//
//	//Return a list containing the amount of nutrients in a given food.
//	public func getNutrients(foodId: Int) -> [FoodItemNutrient] {
//		var nutrients = [FoodItemNutrient]()
//		//TODO finish query url for getting nutrients in a food
//		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
//		let jsonData = makeQuery(queryURL)
//		if jsonData != nil {
//			return jsonToNutrients(jsonData!)
//		}
//		return nutrients
//	}
//
//
//	// MARK: URL Queries
//	//Submits a query request to the database, and returns the json Data
//	private func makeQuery(_ queryURL: String) -> Data? {
//		var returnJsonData: Data?
//		guard let requestUrl = URL(string: queryURL) else {return nil}
//		let request = URLRequest(url:requestUrl)
//		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//			if error == nil, let usableData = data {
//				returnJsonData = usableData
//			}
//		}
//		task.resume()
//
//		return returnJsonData
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
//	private func jsonToAmountPer(_ jsonData: Data) -> AmountPer {
//		//TODO add necessary structs here
//
//		do {
//			//TODO parse json:
//			//let database = try JSONDecoder().decode(?.self, from: jsonData)
//		} catch let jsonErr {
//			print("Error serializing Json:", jsonErr)
//		}
//		return AmountPer() //TODO remove placeholder
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
//
//		do {
//			//TODO parse json:
//			let data = try JSONDecoder().decode(Database.self, from: jsonData)
//			//populate or assign foodItems array
//			//            let list: [item]! = data.list!
//			//            let item: [foodItem]! = list.item!
//			//            //                let name = item!.first!.name
//			//            //                print("list value is: \(name)")
//
//
//			var list = [FoodItem]()
//			//pass name and id to FoodItem array
//			for i in data.list!.item! {
//				//let temp = FoodItem.init(data.list!.item![i].ndbno, data.list!.item![i].name)
//				let temp = FoodItem(Int(i.ndbno ?? "0"), i.name ?? "")
//				list.append(temp)
//
//
//			}
//		} catch let jsonErr {
//			print("Error serializing Json:", jsonErr)
//		}
//
//
//		return foodItems
//	}
//}

