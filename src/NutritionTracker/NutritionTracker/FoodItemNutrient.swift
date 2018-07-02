//
//  FoodItemNutrient.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-01.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

//Amount of a specific nutrient in a food
class FoodItemNutrient {
	var nutrient: Nutrient
	private var amountPer: AmountPer
	
	init(_ nutrient: Nutrient, _ amountPer: AmountPer) {
		self.nutrient = nutrient
		self.amountPer = amountPer
	}
	
	func getNutrient() -> Nutrient { return nutrient }
	func getName() -> String { return nutrient.name; }
	func getAmountPer() -> AmountPer { return amountPer}
}
