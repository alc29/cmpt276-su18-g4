//
//  Nutrient.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

//Used by FoodItem class, represents a specific nutrient, and its amount per some other amount.
class Nutrient {
	//map a nutrient name (key) to it's nutriend_id in the database.
	enum Name: Int {
		case TestBitterNutrientA = 276
		case TestBitterNutrientB = 277
	}
	
	private var name: Name
	private var amountPer: AmountPer

	init(_ name: Name, _ amountPer: AmountPer) {
		self.name = name;
		self.amountPer = amountPer;
	}
	func getName() -> Nutrient.Name { return name; }
	func getAmountPer() -> AmountPer { return amountPer}
	
}
