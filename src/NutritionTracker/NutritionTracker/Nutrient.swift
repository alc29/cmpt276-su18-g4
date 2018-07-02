//
//  Nutrient.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

//Represents a specific nutrient
class Nutrient {
	static let Glucose = Nutrient(211, "Glucose", Unit.Miligram)

	static let TestBitterNutrientA = Nutrient(276, "TestBitterNutrientA", Unit.Miligram)
	static let TestBitterNutrientB = Nutrient(277, "TestBitterNutrientB", Unit.Miligram)
	
	
	let nutrientId: Int
	let name: String
	let unit: Unit

	init(_ nutrientId: Int, _ name: String, _ unit: Unit) {
		self.nutrientId = nutrientId
		self.name = name
		self.unit = unit
	}
}
