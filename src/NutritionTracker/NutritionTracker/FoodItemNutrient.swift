//
//  FoodItemNutrient.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-01.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Represents the amount of a specific nutrient within a specific food.

import Foundation

class FoodItemNutrient {
	// MARK: Properties
	private var nutrient: Nutrient
	private var amountPer: AmountPer
	
	init(_ nutrient: Nutrient, _ amountPer: AmountPer) {
		self.nutrient = nutrient
		self.amountPer = amountPer
	}
	
	// MARK: Setters
	func setNutrient(_ nutrient: Nutrient) {
		self.nutrient = nutrient
	}
	func setBaseAmount(_ amount: Float) {
		amountPer.setBaseAmount(amount)
	}
	
	// MARK: Getters
	func getNutrient() -> Nutrient { return nutrient }
	func getName() -> String { return nutrient.name; }
	func getAmountPer() -> AmountPer { return amountPer}
	func getNutrientId() -> Int { return nutrient.nutrientId }
}
