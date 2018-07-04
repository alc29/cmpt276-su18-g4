//
//  Amount.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-29.
//  Copyright © 2018 alc29. All rights reserved.
//
//	A class for representing an amount of a FoodItem

import Foundation
import RealmSwift

class Amount: Object {
	// MARK: Properties
	@objc dynamic private var amount: Float = 0.0
	@objc dynamic private var unit = Unit.Miligram.rawValue

	convenience init(_ amount: Float? = 0.0, _ unit: Unit? = Unit.Miligram) {
		self.init()
		
		if (amount != nil) {
			if (amount! >= 0) {
				self.amount = amount!
			}
		}
		
		if (unit != nil) {
			self.unit = unit!.rawValue
		}
	}
	
	// MARK: Setters
	func setAmount(_ amount: Float) {
		if (amount >= 0) {
			self.amount = amount
		}
	}
	
	func setUnit(_ unit: Unit) {
		self.unit = unit.rawValue
	}
	
	//MARK: Getters
	func getAmount() -> Float {
		return amount
	}
	func getUnit() -> Unit {
		return Unit(rawValue: unit)!
	}
	
	//MARK: Factory methods
	static func random() -> Amount {
		return Amount(Float(arc4random_uniform(10)))
	}
	
}
