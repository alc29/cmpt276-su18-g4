//
//  Meal.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation
import RealmSwift

class Meal: FoodItemList {
	@objc dynamic var date = Date() //default to current date
	
	func setDate(_ date: Date?) {
		if (date != nil) {
			self.date = date!;
		}
	}
	func getDate() -> Date {
		return date
	}
}
