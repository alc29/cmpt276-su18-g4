//
//  AmountPer.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

//Used by Nutrient class, represents amount of thus nutrient per some amount.
class AmountPer {
	private var amount = Amount()
	private var per = Amount()
	init(amount: Amount = Amount(10.0, Unit.Microgram), per: Amount = Amount(100.0, Unit.Gram)) {
		self.amount = amount
		self.per = per
	}
	func getAmount() -> Amount {
		return amount
	}
	func getPer() -> Amount {
		return per
	}
}
