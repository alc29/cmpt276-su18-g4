//
//  FoodItem.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-28.
//  Copyright © 2018 alc29. All rights reserved.
//
//	A class for representing a specific food.
//	Includes information about the amount of food,
//	as well as food's lookup id in the database.

/*
Since FoodItem is stored locally, variables must be initialized with default values.

*/
import Foundation
import RealmSwift

class FoodItem: Object {
	// MARK: Properties
	@objc private dynamic var id = UUID().uuidString
	@objc private dynamic var foodId = -1
	@objc private dynamic var name = "uninitialized"
	@objc private dynamic var amount: Amount? = Amount()
	//var nutrients = List<FoodItemNutrient>()
	
	//Note: optional initializer FoodItem() works, but should be avoided.
	convenience init(_ foodId: Int?, _ name: String?) {
		self.init()
		
		if (foodId != nil) {
			self.foodId = foodId!
		}
		if (name != nil) {
			self.name = name!
		}
	}
	
	// MARK: Setters
	func setAmount(_ amount: Float, unit: Unit = Unit.GRAM) {
		self.amount!.setAmount(amount)
		self.amount!.setUnit(unit)
	}
	
	//TODO consider moving to Database
	// return the specified amount of nutrient contained in this food.
	func getAmountOf(_ nutrient: Nutrient) -> Float {
		//get nutrient amount info from cached food item in realm.

		//if let foodItemNutrient = getNutrient(nutrient) {
		if let cached = Database5.getCachedFoodItem(self.foodId), let foodItemNutrient = cached.getFoodItemNutrient(nutrient) {
			let amount = foodItemNutrient.getBaseAmount()
			//let per = foodItemNutrient.getAmountPer()
			return amount.getAmount()
		}
	
		//need request? or perform cache check first, before calling this method.
		print("cached food item not found: \(foodId)")
		return Float(0)
	}
	
	//TODO remove
	//retreive nutrient info from cache.
	//TODO if nil, retrieve from database & cache; calling class must call a second time.
	func getNutrient(_ nutrient: Nutrient) -> FoodItemNutrient? {
		if let cachedFoodItem = Database5.getCachedFoodItem(self.foodId),
			let foodItemNutrient = cachedFoodItem.getFoodItemNutrient(nutrient) {
			return foodItemNutrient
		}
		return nil
	}

	// MARK: Getters
	func getFoodId() -> Int { return foodId }
	func getName() -> String { return name }
	func getAmount() -> Amount { return amount! }
	
	//return the pid
	override static func primaryKey() -> String? {
		return "id";
	}
}
