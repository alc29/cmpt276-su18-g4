//
//  FoodItemNutrient.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-01.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Represents the amount of a specific nutrient within a specific food.

import Foundation
import RealmSwift

class FoodItemNutrient: Object {
	// MARK: Properties
	@objc private dynamic var nutrient: Nutrient? = Nutrient.Nil
	@objc private dynamic var amountPer: AmountPer? = AmountPer()
	
	convenience init(_ nutrient: Nutrient, _ amountPer: AmountPer) {
		self.init()
		self.nutrient = nutrient
		self.amountPer = amountPer
	}
	
	// MARK: Setters
//	func setNutrient(_ nutrient: Nutrient) {
//		self.nutrient! = nutrient
//	}
//	func setBaseAmount(_ amount: Float) {
//		amountPer!.setBaseAmount(amount)
//	}
	
	// MARK: Getters
	func getNutrient() -> Nutrient { return nutrient! }
	func getName() -> String { return nutrient!.name; }
	//func getAmountPer() -> AmountPer { return amountPer }
	func getBaseAmount() -> Amount { return amountPer!.getAmount() }
	func getAmountPer() -> Amount { return amountPer!.getPer() }
	func getNutrientId() -> Int { return nutrient!.nutrientId }
}
