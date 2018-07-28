//
//  Meal.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Represents a dated FoodList.

import Foundation
import RealmSwift

class Meal: FoodItemList {
	// MARK: Properties
	@objc dynamic var date = Date() //default to current date
	
	func clone() -> Meal {
		let meal = Meal()
		for foodItem in self.getFoodItems() {
			meal.add(foodItem)
		}
		
		meal.setDate(self.date)
		return meal
	}
	
	// MARK: Setters
	func setDate(_ date: Date?) {
		if let date = date {
			self.date = date
		}
	}
	
	// Mark: Getters
	func getDate() -> Date {
		return date
	}
	
//	func getAmountOf(_ nutrient: Nutrient) -> Float {
//		var sum: Float = 0.0
//		for f in getFoodItems() {
//			sum = sum + f.getAmountOf(nutrient)
//		}
//		return sum
//	}
	
}
