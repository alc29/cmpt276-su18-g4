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
	@objc private dynamic var foodId = -1
	@objc private dynamic var name = "uninitialized"

	//optional initializer; FoodItem() works, but should be avoided.
	convenience init(foodId: Int?, name: String?) {
		self.init()
		
		if (foodId != nil) {
			self.foodId = foodId!
		}
		if (name != nil) {
			self.name = name!
		}
	}

	func getFoodId() -> Int { return foodId }
	func getName() -> String { return name }
}
