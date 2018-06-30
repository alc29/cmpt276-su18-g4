//
//  FoodItem.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-28.
//  Copyright © 2018 alc29. All rights reserved.
//

/*
Since FoodItem is stored locally, variables must be initialized with default values.

*/
import Foundation
import RealmSwift

class FoodItem: Object {
	@objc private dynamic var id = UUID().uuidString
	@objc private dynamic var foodId = -1
	@objc private dynamic var name = "uninitialized"
	@objc private dynamic var amount: Amount? = Amount()

	//optional initializer FoodItem() works, but should be avoided.
	convenience init(_ foodId: Int?, _ name: String?) {
		self.init()
		
		if (foodId != nil) {
			self.foodId = foodId!
		}
		if (name != nil) {
			self.name = name!
		}
	}
	
	func setAmount(_ amount: Float, unit: Unit = Unit.Microgram) {
		self.amount!.setAmount(amount)
		self.amount!.setUnit(unit)
	}

	func getFoodId() -> Int { return foodId }
	func getName() -> String { return name }
	//get amount of food
	func getAmount() -> Amount { return amount! }
	
	//TODO move method to database
	//TODO get amount of given nutrient
	func getAmountOf(_ nutrient: Nutrient) -> Amount {
		//let amount =  database.getAmountOf(nutrient: nutrient, from: foodId);
		return Amount()
	}
	
	override static func primaryKey() -> String? {
		return "id";
	}
}
