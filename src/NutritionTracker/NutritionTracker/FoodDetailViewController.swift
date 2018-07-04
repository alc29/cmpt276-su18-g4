//
//  FoodDetailViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-02.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import Charts

/**
Display a bar chart of what nutrients are in a given FoodItem.
x-axis: a nutrient
y-axis: some AmountPer

The specific nutrients to display can be set by the user.
*/
class FoodDetailViewController: UIViewController {
	@IBOutlet weak var foodName: UILabel!
	@IBOutlet weak var barGraph: BarChartView!
	var nutrientsToDisplay = [Nutrient]()

	var foodItem: FoodItem? {
		didSet { configureView() }
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		//TODO load from settings, the desired nutrients to display
		nutrientsToDisplay.append(Nutrient.TestBitterNutrientA)
		nutrientsToDisplay.append(Nutrient.TestBitterNutrientB)

		configureView()
    }

	func configureView() {
		if let foodItem = foodItem {
			if let foodName = foodName {
				foodName.text = foodItem.getName()
				title = "Food Nutrient Information"

				//display bar graph of foodItem's nutrients
				loadGraph()
			}
		} else {
			foodName.text = "Error: no food item was selected."
			title = "Error"
		}
	}


	func handleJsonData(_ jsonData: Data) {
		//turn jsonData into AmountPer 
		print(jsonData)
	}

	func loadGraph() { //invoker
		var count = 1
		var entries = [BarChartDataEntry]()
		let completion = handleJsonData
		for nut in nutrientsToDisplay {
//			DatabaseWrapper.sharedInstance.getAmountPerOf(nut, foodItem!.getFoodId(), completion)
			//TODO uncomment
			let amountPer = PlaceholderDatabase.sharedInstance.getAmountPerOf(nutrient: nut, foodId: foodItem!.getFoodId())
//			if let amountPer = DatabaseWrapper.sharedInstance.getAmountPerOf(nut, foodItem!.getFoodId()) {
				let amount = amountPer.getAmount().getAmount()
				let entry = BarChartDataEntry(x: Double(count), y: Double(amount))
				entries.append(entry)
				count += 1
//			}

		}
		let dataSet = BarChartDataSet(values: entries, label: "TODO label")
		let data = BarChartData(dataSet: dataSet)
		barGraph.data = data

	}
	
//	func loadGraphAsync() {
		//		var count = 1
		//		var entries = [BarChartDataEntry]()
//		let completion = handleJsonData
//		for nut in nutrientsToDisplay {
//			DatabaseWrapper.sharedInstance.getAmountPerOf(nut, foodItem!.getFoodId(), completion)
			//TODO uncomment
			//let amountPer = PlaceholderDatabase.sharedInstance.getAmountPerOf(nutrient: nut, foodId: foodItem!.getFoodId())
			//			if let amountPer = DatabaseWrapper.sharedInstance.getAmountPerOf(nut, foodItem!.getFoodId()) {
			//				let amount = amountPer.getAmount().getAmount()
			//				let entry = BarChartDataEntry(x: Double(count), y: Double(amount))
			//				entries.append(entry)
			//				count += 1
			//			}
			
//		}
		//		let dataSet = BarChartDataSet(values: entries, label: "TODO label")
		//		let data = BarChartData(dataSet: dataSet)
		//		barGraph.data = data
//	}

}

