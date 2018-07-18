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
	var graphSettings = GraphSettings() //if no settings found, use default settings & save
	//let DEFAULT_TAGS = [Nutrient.Caffeine, Nutrient.Calcium, Nutrient.Sodium] //TODO load tags from user settings
	let DEFAULT_TAGS = [Nutrient.Sugars_total] //TODO load tags from user settings

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		reloadGraphData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		//TODO add flag for if graph needs to be reloaded.
		reloadGraphData()
	}
	
	func reloadGraphData(_ meals: [Meal], cachedFoodItems: [CachedFoodItem]) {
		//TODO call Database5.
	}
	
	// load meals to graph, & other graph settings. graph settings will change what should be displayed on the graph
	func reloadGraphData() {
		let data = LineChartData() //This is the object that will be added to the chart
		let date = graphSettings.getDate() //use date to determine which meals to

		//construct graph data from saved meals, filtered by tags.
		let realm = try! Realm()
		let meals = realm.objects(Meal.self) //(get all meals for testing)
		//TODO only select meals within a certain range
		for nutrient in DEFAULT_TAGS { //for each nutrient tag
			var lineEntries = [ChartDataEntry]() //array for saving data to be plotted on a line.
			for meal in meals { //for each meal
				//determine date of meal
				let dayOfMonth = Calendar.current.ordinality(of: .day, in: .month, for: meal.getDate())
				//determine the amount of the nutrient in the meal

				//create point on the graph & add to array
//				let x = dayOfMonth
				let y = meal.getAmountOf(nutrient)
				let entry = ChartDataEntry(x: 0, y: Double(y))
				print("y entry: \(y)")
				lineEntries.append(entry)
			}
			//create new line plot
			let line = LineChartDataSet(values: lineEntries, label: "\(nutrient.name)")

			//TODO set random line color
			data.addDataSet(line)
		}

		// Set the date of the graph
		let dateFormatter = DateFormatter()
		//dateFormatter.setLocalizedDateFormatFromTemplate(graphSettings.dateFormat)
		let dateStr = dateFormatter.string(from: date)

		graph.data = data
		graph.notifyDataSetChanged()
		graph.chartDescription?.text = dateStr
	}
	


	// MARK: Graph

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

