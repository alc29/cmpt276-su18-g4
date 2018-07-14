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
	@IBOutlet weak var foodNameLabel: UILabel!
	@IBOutlet weak var barGraph: BarChartView!
	var nutrientsToDisplay = [Nutrient]()
	var foodSelector: FoodSelector?

//	var foodItem: FoodItem? {
//		didSet { configureView() }
//	}
	var foodItem = FoodItem(0, "default food item")

    override func viewDidLoad() {
        super.viewDidLoad()
	
//		// load ui elements
//		let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
//		let foodNameLabel = UILabel(frame: rect)
////		label.center = CGPointMake(x: mid)
//		foodNameLabel.textAlignment = NSTextAlignment.center
//		foodNameLabel.text = foodItem.getName()
//		self.view.addSubview(foodNameLabel)
//
//		//TODO load from settings, the desired nutrients to display
//		nutrientsToDisplay.append(Nutrient.Calcium)
//		nutrientsToDisplay.append(Nutrient.Sodium)

		configureView()
    }

	@objc func addButtonPressed(sender: UIBarButtonItem) {
		foodSelector?.addFood(foodItem: foodItem)
	}

	func configureView() {
//		if let foodItem = foodItem {
//			if let foodName = foodNameLabel {
//				foodName.text = foodItem.getName()
//				title = "Food Nutrient Information"
//
//				//display bar graph of foodItem's nutrients
//				loadGraph()
//			}
//		} else {
//			foodNameLabel.text = "Error: no food item was selected."
//			title = "Error"
//		}
		foodNameLabel!.text = foodItem.getName()
	}


//	func loadGraph() { //invoker
//		var count = 1
//		var entries = [BarChartDataEntry]()
//		let completion = handleJsonData
//		for nut in nutrientsToDisplay {
////			Database5.getAmountPerOf(nut, foodItem!.getFoodId(), completion)
//			//TODO uncomment
//			let amountPer = Database5.sharedInstance.getAmountPerOf(nutrient: nut, foodId: foodItem!.getFoodId())
////			if let amountPer = Database5.sharedInstance.getAmountPerOf(nut, foodItem!.getFoodId()) {
//				let amount = amountPer.getAmount().getAmount()
//				let entry = BarChartDataEntry(x: Double(count), y: Double(amount))
//				entries.append(entry)
//				count += 1
////			}
//
//		}
//		let dataSet = BarChartDataSet(values: entries, label: "TODO label")
//		let data = BarChartData(dataSet: dataSet)
//		barGraph.data = data
//
//	}
	
}

