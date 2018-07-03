//
//  DatabaseWrapper.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright � 2018 alc29. All rights reserved.
//
/**
Fake database for testing, until integration with actual.
//TODO rename to Database
AKN
AKN: https://krakendev.io/blog/the-right-way-to-write-a-singleton
https://code.bradymower.com/swift-3-apis-network-requests-json-getting-the-data-4aaae8a5efc0

*/
import Foundation
import RealmSwift


class DatabaseWrapper {
	//MARK: Properties
	static let sharedInstance = DatabaseWrapper()
	private init() {}
	private let KEY = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
	
	// MARK: Public functions
	//return a list of search results as FoodItem's
	public func search(_ searchTerms: String) -> [FoodItem] {
		var foodItems = [FoodItem]()
		//TODO finish query url
		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
		let jsonData = makeQuery(queryURL)
		if jsonData != nil {
			return jsonToFoodItems(jsonData!)
		}
		return foodItems
	}
	
	//return the amount of a specific nutrient in a specific food.
	public func getAmountPerOf(_ nutrient: Nutrient, foodId: Int) -> AmountPer? {
		//TODO finish query url
		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
		let jsonData = makeQuery(queryURL)
		if jsonData != nil {
			return jsonToAmountPer(jsonData!)
		}
		return nil
	}
	
	//Return a list containing the nutrients in a food.
	public func getNutrients(foodId: Int) -> [FoodItemNutrient] {
		var nutrients = [FoodItemNutrient]()
		//TODO finish query url
		let queryURL = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=???????"
		let jsonData = makeQuery(queryURL)
		if jsonData != nil {
			//TODO json for Nutrients, and add them to the array.
		}
		return nutrients
	}
	
	// MARK: URL Queries
	//Takes a query url and returns some data.
	private func makeQuery(_ queryURL: String) -> Data? {
		var returnJsonData: Data?
		guard let requestUrl = URL(string: queryURL) else {return nil}
		let request = URLRequest(url:requestUrl)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if error == nil, let usableData = data {
				returnJsonData = usableData
			}
		}
		task.resume()
		
		return returnJsonData
	}
	
	// MARK: JSON Conversion
	//Takes json Data, and returns an array of Nutrient's.
	private func jsonToNutrients(_ jsonData: Data) -> [Nutrient] {
		var nutrients = [Nutrient]()
		//TODO figure out proper structs:
		/*
		struct JDatabase: Decodable {
			let foods: [JFood]?
		}
		struct JFood: Decodable {
			let nutrients: Nutrient?
			let item: []
		}
		struct JNutrient: Decodable {
			let name: String?
			let value: String?
		}
		*/
		
		do {
			//TODO parse json:
			//let database = try JSONDecoder().decode(JDatabase.self, from: jsonData)
			//populate nutrients array
		} catch let jsonErr {
			print("Error serializing Json:", jsonErr)
		}
		
		return nutrients
	}
	
	//Takes json Data, and returns an AmountPer (amount of a specific nutrient contained in a specific food.)
	private func jsonToAmountPer(_ jsonData: Data) -> AmountPer {
		//TODO add necessary structs here
	
		do {
			//TODO parse json:
			//let database = try JSONDecoder().decode(?.self, from: jsonData)
		} catch let jsonErr {
			print("Error serializing Json:", jsonErr)
		}
		return AmountPer() //TODO remove placeholder
	}
	
	//Takes json data, and returns an array of FoodItem's (search results)
	private func jsonToFoodItems(_ jsonData: Data) -> [FoodItem] {
		var foodItems = [FoodItem]()
		return foodItems
	}
}
