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
	@objc private dynamic var amount: Amount? = Amount() // numerator
	@objc private dynamic var denominator: Amount? = Amount() // denominator

	convenience init(amount: Amount = Amount(0.0, Unit.GRAM), per: Amount = Amount(100.0, Unit.GRAM)) {
		self.init()
		self.amount = amount
		self.denominator = per
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
		return denominator!
	}
}
