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
	//@objc private dynamic var array = [FoodItem]()
	let list = List<FoodItem>()
	
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
	
//	func add(_ foodItem: FoodItem) {
//		array.append(foodItem)
//	}
//
//	func remove(_ index: Int) -> FoodItem? {
//		let count = array.count;
//		if (count > 0 && index >= 0 && index < count) {
//			return array.remove(at: index)
//		}
//		return nil;
//	}
//
//	func count() -> Int {
//		return array.count;
//	}
//
//	func validIndex(_ i: Int) -> Bool {
//		let count = self.count()
//		return (count > 0 && i >= 0 && i < count);
//	}
//
//	func get(_ index: Int) -> FoodItem? {
//		if self.validIndex(index) {
//			return array[index];
//		}
//		return nil;
//	}
	
	override static func primaryKey() -> String? {
		return "id";
	}
}
