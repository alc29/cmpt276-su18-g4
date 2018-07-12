//
//  PlaceholderDatabase.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//
// A fake database for testing, until integration with actual database.

import Foundation
import RealmSwift

class PlaceholderDatabase {
	static let sharedInstance = PlaceholderDatabase()
	private init() {}

	//Return how much of the given nutrient is contained in the food corresponding to foodId
	func getAmountPerOf(nutrient: Nutrient, foodId: Int) -> AmountPer {
		return AmountPer() //TODO replace placeholder
	}

	// Query the database with the given string, and return an array of FoodItem's.
	func search(_ searchTerms: String) -> [FoodItem] {
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

	//given a specific food (id), return a list of the nutrients that the food contains.
	func getNutrients(foodId: Int) -> [FoodItemNutrient] {
		var nutrients = [FoodItemNutrient]()

		//TEST - for now return a fake list of nutrients.
		nutrients.append(FoodItemNutrient(Nutrient.Calcium, AmountPer()))
		nutrients.append(FoodItemNutrient(Nutrient.Sodium, AmountPer()))
		return nutrients
	}
}

