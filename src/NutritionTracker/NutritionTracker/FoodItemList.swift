//
//  FoodItemList.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-29.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation
import RealmSwift

class FoodItemList: Object {
	@objc private dynamic var id = UUID().uuidString
	@objc private dynamic var name = "Untitled List"
	private let list = List<FoodItem>()
	
	//TODO getters & setters for name
	
	func add(_ foodItem: FoodItem) {
		list.append(foodItem)
	}

	func remove(_ index: Int) {
		let count = list.count;
		if (count > 0 && index >= 0 && index < count) {
			list.remove(at: index)
		}
	}
	
	func count() -> Int {
		return list.count;
	}

	func validIndex(_ i: Int) -> Bool {
		let count = self.count()
		return (count > 0 && i >= 0 && i < count);
	}

	func get(_ index: Int) -> FoodItem? {
		if self.validIndex(index) {
			return list[index];
		}
		return nil;
	}
	
	func getFoodItems() -> List<FoodItem> {
		return list
	}
	
	//return total amount of the given nutrient contained in this meal.
	func getAmountOf(nutrient: Nutrient.Name) -> Amount {
		var sum = 0.0 as Float
		for foodItem in list {
			sum += foodItem.getAmountOf(nutrient).getAmount()
		}
		let defaultUnit = Unit.Miligram //TODO use given nutrient's init, or add as arg
		return Amount(sum, defaultUnit)
	}
	
	override static func primaryKey() -> String? {
		return "id";
	}
}
