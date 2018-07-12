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
	@objc dynamic var foodReportV2: FoodReportV2? = FoodReportV2()
	
	func clone() -> Meal {
		let meal = Meal()
		for foodItem in meal.getFoodItems() {
			meal.add(foodItem)
		}
		//TODO copy date
		return meal
	}
	
	// MARK: Setters
	func setDate(_ date: Date?) {
		if (date != nil) {
			self.date = date!;
		}
	}
	
	//Mark: Getters
	func getDate() -> Date {
		return date
	}
	
//	func addNutrientReport(_ report: NutrientReport) {
//		self.nutrientReport!.update(report)
//	}
	
//	func addFoodReportV2(_ report: FoodReportV2) {
//		self.foodReportV2.update(report)
//	}
	
	//replaces the current food report.
	func setFoodReportV2(_ report: FoodReportV2) {
		self.foodReportV2 = report
	}
}
