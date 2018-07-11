//
//  AmountPer.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//
// Class for representing the Amount of a specific nutrient with in a specific food.
// Used by Nutrient class, represents amount of the nutrient per some measurement amount.
// Example usage: 10 grams of calcium per 100 grams of milk.

import Foundation
import RealmSwift

class AmountPer: Object {
	// MARK: Properties
	@objc private dynamic var amount: Amount? = Amount()
	@objc private dynamic var per: Amount? = Amount()

	convenience init(amount: Amount = Amount(10.0, Unit.Microgram), per: Amount = Amount(100.0, Unit.Gram)) {
		self.init()
		self.amount = amount
		self.per = per
	}
	
	//MARK: Setters
	func setBaseAmount(_ amount: Float) {
		self.amount!.setAmount(amount)
	}
	
	// MARK: Getters
	func getAmount() -> Amount {
		return amount!
	}
	
	func getPer() -> Amount {
		return per!
	}
}
