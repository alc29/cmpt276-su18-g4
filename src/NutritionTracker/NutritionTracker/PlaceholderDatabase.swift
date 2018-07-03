//
//  PlaceholderDatabase.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

/*
AKN: https://krakendev.io/blog/the-right-way-to-write-a-singleton
*/
import Foundation
import RealmSwift

/**
Fake database for testing, until integration with actual.
//TODO rename to Database
*/
class PlaceholderDatabase {
	static let sharedInstance = PlaceholderDatabase()
	private init() {}
	
	
	
	//Return how much of the given nutrient is contained in the food corresponding to foodId
	func getAmountPerOf(nutrient: Nutrient, foodId: Int) -> AmountPer {
		/* TODO
		using the foodId, retrieve the corresponding food item, or other relevant info, from the database
		determine the amount of the desired nutrient contained in this food
		create a new AmountPer() using this nutrient data
		return the value
		*/
		return AmountPer() //TODO replace placeholder
	}
	
	// Query the database with the given string, and return an array of FoodItem's.
	func search(_ searchTerms: String) -> [FoodItem] {
		/* TODO
		var array = [FoodItem]()
		query database using searchTerms
		convert the returned json into the proper structs
		convert the structs into FoodItem's
		add the FoodItems to the array
		return array
		*/
		return testSearch()
	}
	
	
	//used for testing - ignore
	private func testSearch() -> [FoodItem] {
		var items = [FoodItem]()
		for i in 0...12 {
			items.append(FoodItem(1000+i, "Searched food item \(i)"))
		}
		return items
	}
	
	//return a list of food items corresponding to the given food group, used to populate Food Group Categories in the catalog, for browsing.
	//func search(foodGroup: FoodGroup) -> [FoodItem] {
		/* TODO
			see FoodGroup.swift
			use foodGroup.name to get the foodgroup's name
			or foodGroup.id to get its id
			return an array of FoodItems that correspond to the foodgroup.
			this is just used to create a list for the user to browse. we can limit it to, say, the first 50, and decide later how to filter results.
	
			later on we'd probably want the same functionality, but for Nutrients instead of FoodGroups. this could be another function, if you have the time.
		*/
	//}

	
	//given a specific food (id), return a list of the nutrients that the food contains.
	func getNutrients(foodId: Int) -> [FoodItemNutrient] {
		var nutrients = [FoodItemNutrient]()
		
		/* TODO
			retrieve the FoodItem that cooresponds to the given foodId
			return a list of the nutrients that the food contains.
			aka return an array of FoodItemNutrient's.
			see below for examples.
		*/
		
		//TEST - for now return a fake list of nutrients.
		nutrients.append(FoodItemNutrient(Nutrient.TestBitterNutrientA, AmountPer()))
		nutrients.append(FoodItemNutrient(Nutrient.TestBitterNutrientB, AmountPer()))
		return nutrients
	}
}


