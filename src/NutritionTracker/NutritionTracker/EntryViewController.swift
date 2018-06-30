//
//  EntryViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import RealmSwift

class EntryViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//clear all persistent data from the last run.
		clearRealmData()
		addTestMeals()
		
		
	}
	
	//Testing - clear all persistent data
	//(note: if migration required, must erase all content from device & restart.)
	private func clearRealmData() {
		let realm = try! Realm()
		try! realm.write {
			realm.deleteAll()
		}
	}
	
	//Testing - create test meals to display in graph
	private func addTestMeals() {
		let realm = try! Realm()
		try! realm.write {
			for _ in 0..<5 {
				let meal = Meal()
				for j in 0..<2 {
					let foodItem = FoodItem(j, "food item: \(j)")
					foodItem.setAmount(Float(arc4random_uniform(5)))
					meal.add(foodItem)
					let date = Date()
					meal.setDate(date)
				}
				realm.add(meal)
			}
			
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

