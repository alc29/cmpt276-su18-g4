//
//  EntryViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//
//	ViewController for the app entry/launch screen. Contains initialization logic.
// 	TODO add an interesting splash screen/logo/grpahic

import UIKit
import RealmSwift

class EntryViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Testing - clear all persistent data from the last test run.
		clearRealmData()
		//add fake meals for testing the app.
		addTestMeals()
		
		
//		DatabaseWrapper.sharedInstance.getNutrientsAsync("haHAAAAAA", printString)
		DatabaseWrapper.sharedInstance.makeQuery("https://api.nal.usda.gov/ndb/V2/reports/?ndbno=01009&format=json&api_key=Y5qpjfCGqZ9mTIhN41iKHAGMIKOf42uS2mH3IQr4", handleData)
	}
	
	func handleData(_ data: Data? ) {
		if (data != nil) {
			print(data!)
		}
	}
	
	//Testing - clear all persistent data
	//(note: if migration required, must erase all content from device & restart.)
	private func clearRealmData() {
		let realm = try! Realm()
		try! realm.write {
			realm.deleteAll()
		}
	}

	
	//Testing - create and add test meals to display in graph
	private func addTestMeals() {
		var daysToAdd = 1
		
		let realm = try! Realm()
		try! realm.write {
			for _ in 0..<5 {
				let meal = Meal()
				for j in 0..<2 {
					let foodItem = FoodItem(j, "food item: \(j)")
					foodItem.setAmount(Float(arc4random_uniform(5)))
					meal.add(foodItem)
				}
				let nextDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date())
				daysToAdd += 1
				meal.setDate(nextDate)
				realm.add(meal)
			}
			
		}
	}

}

