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
	let sort = "n"      // n: sort by name, r: search by relevence
	let max = "25"      // max items to return

	
	func emptyCompletionHandler(_ data: Data) {
		print("empty completion handl")
	}

	typealias DataCompletion = (_ data: Data) -> Void

	// MARK: Public functions
	//return a list of search results as FoodItem's
	public func search(_ searchTerms: String, _ completion: @escaping DataCompletion) {
		let q = searchTerms
		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(q)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
		let jsonData = makeQuery(queryURL, completion)

	}

	//Return a list of FoodItem's corresponding to the given FoodGroup.
	public func getFoodItemsFrom(_ foodGroupId: String, _ completion: @escaping DataCompletion) { //-> [FoodItem]()
		let fg = foodGroupId
		// query url for getting foods in a FoodGroup (using the food group id)
		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&fg=\(fg)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
		makeQuery(queryURL, completion)
	}

	//return the amount of a specific nutrient in a specific food.
	public func getAmountPerOf(_ nutrient: Nutrient, _ foodId: Int, _ completion: @escaping DataCompletion) {
		let ndbno = foodId
		//query url for getting the amount of a specific nutrient in the food.
		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&ndbno=\(ndbno)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
		makeQuery(queryURL, completion)
	}

	//Return a list containing the amount of nutrients in a given food.
	public func getNutrients(foodId: Int) { //-> [FoodItemNutrient]
		//var nutrients = [FoodItemNutrient]()
		let ndbno = foodId
		// query url for getting nutrients in a food
		//TODO query needs to be a "report", not a "search"
		let queryURL = "https://api.nal.usda.gov/ndb/search/?format=json&ndbno=\(ndbno)&sort=\(sort)&max=\(max)&offset=0&api_key=\(KEY)"
		makeQuery(queryURL, emptyCompletionHandler)
	}


	// MARK: URL Queries
	//Submits a query request to the database, and returns the json Data
	func makeQuery(_ queryURL: String, _ completion: @escaping DataCompletion) {
		print("query received")
		guard let requestUrl = URL(string: queryURL) else {return}
		let request = URLRequest(url:requestUrl)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data else {
				print("makeQuery: error loading data")
				return
			}
			completion(data)
		}
		task.resume()
	}

	// MARK: JSON Conversion
	//Takes json Data, and returns an array of Nutrient's.
	func jsonToNutrients(_ jsonData: Data) -> [FoodItemNutrient] {

		struct Database: Decodable {
			let foods: [Food]?
		}
		struct Food: Decodable {
			let food: NutrientStruct?
		}
		struct NutrientStruct: Decodable {
			let nutrients: [Nutrients]?
		}
		struct Nutrients: Decodable {
			let nutrient_id: Int?
			let name: String?
			let unit: String?
			let value: Float?
		}

		var nutrientsToReturn = [FoodItemNutrient]()
		do {
			//TODO parse json:
			let data = try JSONDecoder().decode(Database.self, from: jsonData)
			//populate or assign nutrients array
			//guard let data = data else { return nutrients }
			guard let foods = data.foods else { return nutrientsToReturn }
			guard let first = foods.first else { return nutrientsToReturn }
			guard let food = first.food else { return nutrientsToReturn }
			guard let nutrients = food.nutrients else { return nutrientsToReturn }
			for n in nutrients {
				let grams = Unit.Gram
				let tempNutrient = Nutrient(n.nutrient_id!, n.name!, grams)
				let tempAmount = AmountPer(amount: Amount(n.value, Unit.Gram), per: Amount(100, Unit.Gram))
				let tempFoodItemNutrient = FoodItemNutrient(tempNutrient, tempAmount)
				nutrientsToReturn.append(tempFoodItemNutrient)
			}

		} catch let jsonErr {
			print("Error serializing Json:", jsonErr)
		}
		return nutrientsToReturn
	}


	//Takes json Data, and returns an AmountPer (amount of a specific nutrient contained in a specific food.)
	func jsonToAmountPer(_ jsonData: Data, _ nutrient: Nutrient) -> AmountPer {
		//TODO add necessary structs here
		struct Database: Decodable {
			let foods: [Food]?
		}
		struct Food: Decodable {
			let food: NutrientStruct?
		}
		struct NutrientStruct: Decodable {
			let nutrients: [Nutrients]?
		}
		struct Nutrients: Decodable {
			let nutrient_id: Int?
			let name: String?
			let unit: String?
			let value: Float?
		}

		// variables
		var value = Float()
		var nutrientVal = AmountPer()

		do {
			//TODO parse json:
			let data = try JSONDecoder().decode(Database.self, from: jsonData)

			
			for i in data.foods!.first!.food!.nutrients! {
				if (i.name == nutrient.name) {
					value = i.value!
				}
				nutrientVal = AmountPer(amount: Amount(value, Unit.Gram), per: Amount(100, Unit.Gram))
			}

		} catch let jsonErr {
			print("Error serializing Json:", jsonErr)
		}

		return nutrientVal //TODO remove placeholder
	}


	//Takes json data, and returns an array of FoodItem's (search results)
	func jsonToFoodItems(_ jsonData: Data) -> [FoodItem] {
		var foodItems = [FoodItem]()

		// Structs for containing json variables
		struct Database: Decodable {
			let list: List?
		}

		struct List: Decodable {
			let item: [Items]?
		}

		struct Items: Decodable {
			let name: String?
			let group: String? // food group
			let ndbno: String?
		}
		do {
			//TODO parse json:
			let data = try JSONDecoder().decode(Database.self, from: jsonData)

			//pass name and id to FoodItem array
			for i in data.list!.item! {
				let temp = FoodItem(Int(i.ndbno!), i.name!)
				foodItems.append(temp)
			}
		} catch let jsonErr {
			print("Error serializing Json:", jsonErr)
		}

		return foodItems
	}
}

