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
	func setAmount(_ amount: Float, unit: Unit = Unit.Microgram) {
		self.amount!.setAmount(amount)
		self.amount!.setUnit(unit)
	}

	// MARK: Getters
	func getFoodId() -> Int { return foodId }
	func getName() -> String { return name }
	func getAmount() -> Amount { return amount! }
	
	// MARK: Public methods
//	
//	// Return how much of the specified nutrient this food contains.
//	func getAmountOf(_ nutrient: Nutrient) -> Amount {
//
//		//TODO: uncomment when database is ready.
//		//if let amount = DatabaseWrapper.sharedInstance.getAmountPerOf(nutrient, foodId) {
//		//	return amount.getAmount()
//		//}
//		//return Amount(0)
//		
//		DatabaseWrapper.sharedInstance.getAmountPerOf(nutrient, foodId, updateAmount)
//		
//		//return Amount.random() //return a random amount for testing.
//	}
//	private func updateAmount(_ data: Data?) {
//		if (data != nil) {
//			amount = DatabaseWrapper.sharedInstance.jsonToAmountPer(data, )
//		}
//	}
	
	//return the pid
	override static func primaryKey() -> String? {
		return "id";
	}
}
