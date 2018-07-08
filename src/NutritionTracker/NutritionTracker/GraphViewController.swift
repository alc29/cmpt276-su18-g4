//
//  GraphViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//
// 	ViewController for the Graph. Displays a grpah of the user's saved meals.
//	(TODO) The user may choose which nutrients they wish to have displayed in the grpah.
//

import UIKit
import RealmSwift
import Charts

/** Controls graph behaviour & data **/
class GraphViewController: UIViewController {
	//MARK: Properties
	@IBOutlet weak var graph: LineChartView! //ref to view in the storyboard
	//var graphSettings: GraphSettings? //if no settings found, use default settings & save
	let DEFAULT_TAGS = [Nutrient.Caffeine, Nutrient.Calcium, Nutrient.Sodium] //TODO load tags from user settings
	// let nutrientReport
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	
	
	
	//update the data that should fill this graph.
//	private func requestNutrientReport() {
//		//get meals within desired timeframe
//		let realm = try! Realm()
//		let meals = realm.objects(Meal.self) //(get all meals for testing)
//		let tags = DEFAULT_TAGS
//
//		//request nutrient report for every food item
//		let foodItems = [FoodItem]()
//		for meal in meals { //for every food item in the meal
//			for foodItem in meal.getFoodItems() {
//			}
//		}
//		Database5.sharedInstance.requestNutrientReport(foodItem.getFoodId(), tags, receiveNutrientReport)
//	}
	
//	func receiveNutrientReport(_ nutrientReport: FoodNutrientReport) {
//	}
	
	//callback for nutrient report requests. add data to graph when nutrient report received.
//	func loadGraphData() {
//		// TODO use existing nutrient report, otherwise request new one
//
//		//TODo append instead of resetting graph data; save as instance var
//
//		let data = LineChartData() //This is the object that will be added to the chart
//		//let date = graphSettings!.getDate() //use date to determine which meals to
//
//
//		//construct graph data from saved meals, filtered by tags.
//		let realm = try! Realm()
//		let meals = realm.objects(Meal.self) //(get all meals for testing)
//		for tag in DEFAULT_TAGS { //for each nutrient tag
//			var lineEntries = [ChartDataEntry]() //array for saving data to be plotted on a line.
//			for meal in meals { //for each meal
//				//determine date of meal
//				let dayOfMonth = Calendar.current.ordinality(of: .day, in: .month, for: meal.getDate())
//				//determine the amount of the nutrient in the meal
//
//				for foodItem in meal.getFoodItems() {
//					let nutrientItemAmount = nutrientReport.getFoodItemNutrient()
//
//				}
//				//let nutrientAmount = getAmountOfNutrientInMeal(tag, meal)
//
////				//create point on the graph & add to array
////				let entry = ChartDataEntry(x: Double(dayOfMonth!), y: Double(nutrientAmount.getAmount()))
////				lineEntries.append(entry)
//			}
////			//create new line plot
////			let line = LineChartDataSet(values: lineEntries, label: "\(tag.name)")
////
////			//TODO set random line color
////			data.addDataSet(line)
//		}

//		// Set the date of the graph
//		let dateFormatter = DateFormatter()
//		//TODO dateFormatter.setLocalizedDatFormatFromTemplate(graphSettings.dateFormat)
//		let dateStr = dateFormatter.string(from: date)

//		resetGraph(data, dateStr)
//		print("nutrient report rexeiced.")
//	}
	


	// MARK: Graph

	// Remove old data, reload graph with new data
	private func resetGraph(_ data: LineChartData, _ date: String) {
		graph.data = data
		graph.notifyDataSetChanged()
		graph.chartDescription?.text = date
	}
	
	//AKN: https://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1
	func randColor() -> UIColor {
		let r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}


    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
}

/** A class used for saving graph-related settings. */
class GraphSettings: Object {
	//MARK: Properties
	@objc var selectedDate = Date() //the date the graph should display when first loading.
	//@objc var dateFormat:
	//var unit = Unit.Micrograms // The unit that the graph should be displayed in.
	
	//MARK: Getters
	func getDate() -> Date {
		return selectedDate
	}
	
	//MARK: Setters
	//TODO func setDate() {}
	
}

