//
//  NutrientReport.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-05.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

//nutrient information about a food
class FoodNutrientReport {
	//Map: FoodItem -> List of FoodItemNutrients
	let foodId: Int //the id of the associated food item
	var nutrients = [FoodItemNutrient]()
	
	init (_ foodId: Int) {
		self.foodId = foodId
	}
	
	func addNutrient(_ nutrient: FoodItemNutrient) {
		let isDuplicate = nutrients.contains { n in nutrient.getName() == n.getName() }
		if (!isDuplicate) {
			nutrients.append(nutrient)
		}
	}
	
	func getNutrients() -> [FoodItemNutrient] {
		return nutrients
	}
	
	func testPrint() {
		print("poggers")
	}
	
}
