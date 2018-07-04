////
////  PlaceholderDatabase.swift
////  NutritionTracker
////
////  Created by alc29 on 2018-06-30.
////  Copyright � 2018 alc29. All rights reserved.
////
//
////Rough functios
//
///*
//AKN: https://krakendev.io/blog/the-right-way-to-write-a-singleton
//*/
//import Foundation
//import RealmSwift
//
///**
//Fake database for testing, until integration with actual.
////TODO rename to Database
//*/
//class PlaceholderDatabase {
//	static let sharedInstance = PlaceholderDatabase()
//	private init() {}
//	
//	
//	
//	//Return how much of the given nutrient is contained in the food corresponding to foodId
//	func getAmountPerOf(nutrient: Nutrient, foodId: Int) -> AmountPer {
//		/* TODO
//		using the foodId, retrieve the corresponding food item, or other relevant info, from the database
//		determine the amount of the desired nutrient contained in this food
//		create a new AmountPer() using this nutrient data
//		return the value
//		*/
//		
//		//uses: https://api.nal.usda.gov/ndb/V2/reports?ndbno=01009&type=f&format=json&api_key=DEMO_KEY
//		//Structs need to be structured like the api
//		
//		// Structs for containing json variables
//		struct Database: Decodable{
//			let foods: Food?
//		}
//		
//		struct Food: Decodable {
//			let desc: Desc?
//			let nutrients: [Nutrients]?
//		}
//		
//		struct Desc: Decodable {
//			let name: String?
//			let fg: String? // food group
//			let ndbno: String?
//		}
//		
//		struct Nutrients: Decodable {
//			let name: String?
//		}
//		
//		// Search Api URL using searchTerms
//		let q = foodId    // input to be searched by database
//		let sort = "n"      // n: sort by name, r: search by relevence
//		let max = "25"      // max items to return
//		let key = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
//		
//		let jsonData = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(q)&sort=\(sort)&max=\(max)&offset=0&api_key=\(key)"
//		guard let url = URL(string: jsonData) else { return }
//		
//		// Load Json
//		URLSession.shared.dataTask(with: url) { (data, response, err) in
//			//check err
//			//print("error with URLSession")
//			
//			guard let data = data else { return }
//			//create a json object and store as 'database'
//			do {
//				let database = try JSONDecoder().decode(Database.self, from: data)
//				
//				// use database.foods!.food!.first!.desc!.name, database.foods!.food!.first!.desc!.fg, database.foods!.food!.first!.nutrients!.name, database.foods!.food!.first!.nutrients!.value and pass into AmountPer()
//				
//				return AmountPer() //TODO replace placeholder
//			} catch let jsonErr {
//				print("Error serializing Json:", jsonErr)
//			}
//			}.resume()
//		
//		// Query the database with the given string, and return an array of FoodItem's.
//		func search(_ searchTerms: String) -> [FoodItem] {
//			/* TODO -> In progress
//			var array = [FoodItem]()
//			query database using searchTerms
//			convert the returned json into the proper structs
//			convert the structs into FoodItem's
//			add the FoodItems to the array
//			return array
//			*/
//			
//			
//			//uses: https://api.nal.usda.gov/ndb/search/?format=json&q=butter&it=g&sort=n&max=25&offset=0&api_key=Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4
//			//Structs need to be structured like the api
//			
//			// Structs for containing json variables
//			struct Database {
//				let list: List?
//			}
//			
//			struct List: Decodable {
//				let item: [Items]?
//			}
//			
//			struct Items: Decodable {
//				let name: String?
//				let group: String? // food group
//				let ndbno: String?
//			}
//			
//			
//			// Search Api URL using searchTerms
//			let q = searchTerms    // input to be searched by database
//			let sort = "n"      // n: sort by name, r: search by relevence
//			let max = "25"      // max items to return
//			let key = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
//			
//			let jsonData = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(q)&sort=\(sort)&max=\(max)&offset=0&api_key=\(key)"
//			//print("api link is:", jsonData)
//			
//			guard let url = URL(string: jsonData) else { return }
//			
//			URLSession.shared.dataTask(with: url) { (data, response, err) in
//				//check err
//				//print("error with URLSession")
//				
//				guard let data = data else { return }
//				//create a json object and store as 'database'
//				do {
//					let database = try JSONDecoder().decode(Database.self, from: data)
//					
//					//print("list value is:", database.list?.q)
//					
//					//                let list: List! = database.list!
//					//                let item: [foodItems]! = list.item!
//					//                let name = item!.first!.name
//					//                print("list value is: \(name)")
//					
//					var list = [FoodItem]()
//					//pass name and id to FoodItem array
//					for i in database.list!.item! {
//						let temp = FoodItem.init(database.list!.item![i].ndbno, database.list!.item![i].name)
//						list.append(temp)
//					}
//					
//					//need to return list
//					
//					
//				} catch let jsonErr {
//					print("Error serializing Json:", jsonErr)
//				}
//				}.resume()
//			
//			return testSearch()
//		}
//		
//		
//		//used for testing - ignore
//		private func testSearch() -> [FoodItem] {
//			var items = [FoodItem]()
//			for i in 0...12 {
//				items.append(FoodItem(1000+i, "Searched food item \(i)"))
//			}
//			return items
//		}
//		
//		//return a list of food items corresponding to the given food group, used to populate Food Group Categories in the catalog, for browsing.
//		//func search(foodGroup: FoodGroup) -> [FoodItem] {
//		/* TODO
//		see FoodGroup.swift
//		use foodGroup.name to get the foodgroup's name
//		or foodGroup.id to get its id
//		return an array of FoodItems that correspond to the foodgroup.
//		this is just used to create a list for the user to browse. we can limit it to, say, the first 50, and decide later how to filter results.
//		
//		later on we'd probably want the same functionality, but for Nutrients instead of FoodGroups. this could be another function, if you have the time.
//		*/
//		//}
//		
//		
//		//given a specific food (id), return a list of the nutrients that the food contains.
//		func getNutrients(foodId: Int) -> [FoodItemNutrient] {
//			var nutrients = [FoodItemNutrient]()
//			
//			/* TODO
//			retrieve the FoodItem that cooresponds to the given foodId
//			return a list of the nutrients that the food contains.
//			aka return an array of FoodItemNutrient's.
//			see below for examples.
//			*/
//			
//			// Json Structs
//			
//			// uses: https://api.nal.usda.gov/ndb/V2/reports?ndbno=01009&type=f&format=json&api_key=DEMO_KEY
//			// Structs need to be created exactly like the api
//			
//			struct Database: Decodable{
//				let foods: [Food]?
//			}
//			
//			struct Food: Decodable {
//				let nutrients: Nutrient?
//				let item: [foodItems]?
//			}
//			
//			struct Nutrient: Decodable {
//				let name: String?
//				let value: String?
//			}
//			
//			// Search Api URL
//			let ndbno = String(foodId)    // input to be searched by database
//			let key = "Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4"
//			
//			let jsonData = "https://api.nal.usda.gov/ndb/V2/reports?ndbno=\(ndbno)&type=f&format=json&api_key=\(key)"
//			
//			guard let url = URL(string: jsonData) else { return }
//			
//			URLSession.shared.dataTask(with: url) { (data, response, err) in
//				//check err
//				//print("error with URLSession")
//				
//				guard let data = data else { return }
//				
//				do {
//					let database = try JSONDecoder().decode(Database.self, from: data)
//					
//					//pass nutrients into an array
//					
//				} catch let jsonErr {
//					print("Error serializing Json:", jsonErr)
//				}
//				}.resume()
//			
//			
//			//TEST - for now return a fake list of nutrients.
//			nutrients.append(FoodItemNutrient(Nutrient.TestBitterNutrientA, AmountPer()))
//			nutrients.append(FoodItemNutrient(Nutrient.TestBitterNutrientB, AmountPer()))
//			return nutrients
//		}
//		
//}

