//
//  CachedFoodItem.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-28.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation
import RealmSwift

class CachedFoodItem: Object {
	@objc private dynamic var id = UUID().uuidString
	@objc private dynamic var foodId: Int = -1
	let nutrients = List<FoodItemNutrient>()
	
	//NOTE: call from within write block.
	convenience init(_ foodId: Int, _ nutrients: [FoodItemNutrient]) {
		self.init()
		self.foodId = foodId
		self.nutrients.append(objectsIn: nutrients)
	}
	
//	func addFoodItemNutrient(_ foodItemNutrient: FoodItemNutrient) {
//		//TODO handle duplicates
//		if foodItemNutrient.getNutrientId() <= 0 {
//			print("warning: id of foodItemNutrient is: \(foodItemNutrient.getNutrientId())")
//		}
//		nutrients.append(foodItemNutrient)
//	}
	
	func getFoodItemNutrient(_ nutrient: Nutrient) -> FoodItemNutrient? {
		for n in nutrients {
			if n.getNutrient().getId() == nutrient.getId() {
				return n
			}
		}
		return nil
	}
	
	func getFoodId() -> Int {
		return foodId
	}
	
	//return the pid
	override static func primaryKey() -> String? {
		return "id";
	}
}
