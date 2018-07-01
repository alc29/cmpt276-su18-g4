//
//  PlaceholderDatabase.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

/*
AKN: https://krakendev.io/blog/the-right-way-to-write-a-singleton
*/
import Foundation
import RealmSwift

/**
Fake database for testing, until integration with actual.
*/
class PlaceholderDatabase {
	static let sharedInstance = PlaceholderDatabase()
	private init() {}
	
	//let amount =  PlaceholderDatabase.sharedInstance.getAmountOf(nutrient: nutrient, fromFoodId: foodId);
	func getAmountOf(nutrient: Nutrient.Name, fromFoodId: Int) -> Amount {
		//return standard amount of the nutrient that corresponds to the food (foodId)
		return Amount()
	}
	
	func getNutrients(fromFoodId: Int) -> [Nutrient] {
		//return an array of nutrients corresponding to the given foodId
		var nutrients = [Nutrient]()
		//TODO get food from database, and create list of nutrients.
		
		//TEST - for now return a fake list of nutrients.
		nutrients.append(Nutrient(Nutrient.Name.TestBitterNutrientA, AmountPer()))
		nutrients.append(Nutrient(Nutrient.Name.TestBitterNutrientB, AmountPer()))
		return nutrients
	}
}
