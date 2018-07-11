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
	@objc dynamic var nutrientReport: NutrientReport? = NutrientReport()
	
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
	
	func addNutrientReport(_ report: NutrientReport) {
		self.nutrientReport!.update(report)
	}
}
