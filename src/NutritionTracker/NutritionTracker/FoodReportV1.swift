//
//  FoodReportV1.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-14.
//  Copyright © 2018 alc29. All rights reserved.
//

import Foundation
import RealmSwift

/**
*/
class FoodReportV1 {
	// Not legacy
	struct Result: Decodable {
		let report: Report?
		
		struct Report: Decodable {
			let sr: String? // legacy or other
			let food: JFood?
		}
		
		struct JFood: Decodable {
			let ndbno: String?
			let name: String?
			let nutrients: [JNutrient?]?
		}
		struct JNutrient: Decodable {
			let nutrient_id: String?
			let name: String?
			let derivation: String?
			let group: String?
			let unit: String?
			let value: String?
			let measures: [JMeasure?]?
		}
		struct JMeasure: Decodable {
			let label: String?
			let eqv: Int?
			let eunit: String?
			let qty: Int?
			let value: String? //gram equivalent value of the measure
		}
	}
	
	
	//Legacy
	struct LegacyResult: Decodable {
		let report: Report?
		
		struct Report: Decodable {
			let sr: String? // legacy or other
			let food: JFood?
		}
		
		struct JFood: Decodable {
			let ndbno: String?
			let name: String?
			let sd: String?
			let fg: String?
			let nutrients: [JNutrient?]?
		}
		struct JNutrient: Decodable {
			let nutrient_id: Int?
			let name: String?
			let derivation: String?
			let group: String?
			let unit: String?
			let value: Float?
			let measures: [JMeasure?]?
		}
		struct JMeasure: Decodable {
			let label: String?
			let eqv: Int?
			let eunit: String?
			let qty: Int?
			let value: Float? //gram equivalent value of the measure
		}
		
	}
	
	
	//MARK: Properties
	//TODO convert all jFoods in Result into FoodItems.
//	var jFoods = [Result.JFood]()
	var result: Any?

//	static func jNutrientToFoodItemNutrient(_ jNutrient: FoodReportV2.Result.JFood.JNutrient) -> FoodItemNutrient? {
//		guard let nutrient_id = jNutrient.nutrient_id else { print("no nutrient_id found."); return nil }
//
//		let nutrientId = Int(nutrient_id) //string to int
//		let nutrient = Nutrient.get(id: nutrientId!)
//		//let baseAmount = Amount(Float(jNutrient.value!)!, Unit.get(jNutrient.unit!)!) //TODO
//		let baseAmount = Amount()
//		let ratioAmount = Amount(100.0, Unit.Gram) //TODO
//		let amountPer = AmountPer(amount: baseAmount, per: ratioAmount)
//
//		return FoodItemNutrient(nutrient, amountPer)
//	}
	
	
	//cache food items & nutrient data
	
	//TODO split into two functions
	
	static func cacheFromJsonData(_ jsonData: Data, _ debug: Bool = false) -> FoodReportV1? {
		do { //non legacy
			let result = try JSONDecoder().decode(FoodReportV1.Result.self, from: jsonData)
			if let report = result.report, let sr = report.sr {
				if sr != "Legacy" {
					let foodReportV1 = FoodReportV1()
					foodReportV1.result = result
					
					// get nutrients from jFood, convert to FoodItemNutrient; add to food item
					if let report = result.report,
						let jFood = report.food, let ndbno = jFood.ndbno,
						let foodId = Int(ndbno), let foodName = jFood.name {
						//let foodItem = FoodItem(foodId, foodName)
						let cachedFoodItem = CachedFoodItem(foodId)
						
						if let jNutrients = jFood.nutrients {
							for jNutrient in jNutrients {
								guard let jNutrient = jNutrient, let nutrient_id = jNutrient.nutrient_id else { continue }
								
								let nutrientId = Int(nutrient_id)
								let nutrient = Nutrient.get(id: nutrientId!)
								
								let amount = Amount() //TODO
								let per = Amount(100, Unit.Gram) //TODO
								let amountPer = AmountPer(amount: amount, per: per)
								
								let foodItemNutrient = FoodItemNutrient(nutrient, amountPer)
								//foodItem.addNutrient(foodItemNutrient)
								//add foodItemNutrient to cache
								cachedFoodItem.addFoodItemNutrient(foodItemNutrient)
							}
						}
						//Database5.cacheFoodItem(cachedFoodItem)
						DispatchQueue.main.async {
							let realm = try! Realm()
							try! realm.write {
								realm.add(cachedFoodItem)
							}
						}
					}
					return foodReportV1
				}
			
			}
			
			
		} catch {
			print("now trying legacy")
		}
		
		
		//Try decoding legacy
		do {
			let result = try JSONDecoder().decode(FoodReportV1.LegacyResult.self, from: jsonData)
			let foodReportV1 = FoodReportV1()
			foodReportV1.result = result
			
			// get nutrients from jFood, convert to FoodItemNutrient; add to food item
			if let report = result.report,
				let jFood = report.food, let ndbno = jFood.ndbno,
				let foodId = Int(ndbno), let foodName = jFood.name {
				//let foodItem = FoodItem(foodId, foodName)
				let cachedFoodItem = CachedFoodItem(foodId)
				
				if let jNutrients = jFood.nutrients {
					for jNutrient in jNutrients {
						guard let jNutrient = jNutrient, let nutrient_id = jNutrient.nutrient_id else { continue }
						
						let nutrient = Nutrient.get(id: Int(nutrient_id))
						
						let amount = Amount() //TODO
						let per = Amount(100, Unit.Gram) //TODO
						let amountPer = AmountPer(amount: amount, per: per)
						
						let foodItemNutrient = FoodItemNutrient(nutrient, amountPer)
						//foodItem.addNutrient(foodItemNutrient)
						//add foodItemNutrient to cache
						cachedFoodItem.addFoodItemNutrient(foodItemNutrient)
					}
				}
				DispatchQueue.main.async {
					let realm = try! Realm()
					try! realm.write {
						realm.add(cachedFoodItem)
					}
				}
				//Database5.cacheFoodItem(cachedFoodItem)
			}
			return foodReportV1
			
			
		} catch let error {
			print(error)
		}
		
		return nil
	}
	
	
}


