//
//  FoodItemList.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-29.
//  Copyright © 2018 alc29. All rights reserved.
//
//	Represents a mutable list of FoodItem's

import Foundation
import RealmSwift

class FoodItemList: Object {
	// MARK: Properties
	@objc private dynamic var id = UUID().uuidString
	@objc private dynamic var name = "Untitled List"
	private let list = List<FoodItem>()
	
	// MARK: Public methods
	
	// Add a fooditem to this list
	func add(_ foodItem: FoodItem) {
		//TODO check for duplicates
		list.append(foodItem)
	}

	// Remove the food item at the specified index.
	func remove(_ index: Int) {
		let count = list.count;
		if (count > 0 && index >= 0 && index < count) {
			list.remove(at: index)
		}
	}
	
	// Return the number of items in this list.
	func count() -> Int {
		return list.count;
	}

	// Return true iff the given index is within bounds.
	func validIndex(_ i: Int) -> Bool {
		let count = self.count()
		return (count > 0 && i >= 0 && i < count);
	}

	// return the food item at the given index, or nil
	func get(_ index: Int) -> FoodItem? {
		if self.validIndex(index) {
			return list[index];
		}
		return nil;
	}
	
	//return the food item with the corresponding id
	func get(id: Int) -> FoodItem? {
		for foodItem in list {
			if foodItem.getFoodId() == id {
				return foodItem
			}
		}
		return nil
	}
	
	// return a list of all the food items.
	func getFoodItems() -> List<FoodItem> {
		return list
	}
	
	// return the primery id key
	override static func primaryKey() -> String? {
		return "id";
	}
}
