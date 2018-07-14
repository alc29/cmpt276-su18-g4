//
//  Unit.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-29.
//  Copyright © 2018 alc29. All rights reserved.
//
//	An enum for representing all possible units of measurement.

import Foundation
import RealmSwift

enum Unit: String {
	case Gram
	case Miligram
	case Microgram
	case IU //international unit
	case KJ
	case KCAL
	
	static func get(_ rawValue: String) -> Unit? {
		return Unit(rawValue: rawValue)
	}
}
