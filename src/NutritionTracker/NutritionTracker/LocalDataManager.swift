//
//  LocalDataManager.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-28.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation
import RealmSwift

class LocalDataManager {
	static let sharedInstance = LocalDataManager()
	private init() {}
	
//	func saveMeal(newMeal: String) { //TODO Meal Class
//		let realm = try! Realm()
//		try!realm.write {
//			//TODO add new Meal to list of user's meals
//			//realm.add(newMeal)
//		}
//	}
//
//	func getMeals() {
//
//	}
}
