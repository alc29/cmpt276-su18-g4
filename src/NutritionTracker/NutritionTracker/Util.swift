//
//  Util.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-14.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation

class Util {
	static func dataToString(_ data: Data) -> String {
		return String(data: data, encoding: .utf8)!
	}
}
