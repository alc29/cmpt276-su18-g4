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
	let DEFAULT_TAGS = [Nutrient.Sugars_total, Nutrient.Calcium, Nutrient.Sodium] //TODO load tags from user settings
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// For formatting the x-axis
		let xAxis = graph.xAxis
		xAxis.labelPosition = .bottom
		xAxis.granularity = 1
		xAxis.labelCount = 3
		// This function takes in the x value from, for example: let entry = ChartDataEntry(x: 1, y: 5)
		// and converts it into a date value. 1 = Jan 1, 365 = Dec 25, 366 = Jan 1
		// Years have been turned off, but can be re-enabled from -> Formatters: DayAxisValueFormatter.swift line: 33
		xAxis.valueFormatter = DayAxisValueFormatter(chart: graph)
		
		// For formatting the left y-axis labels
		let leftAxisFormatter = NumberFormatter()
		leftAxisFormatter.minimumFractionDigits = 0
		leftAxisFormatter.maximumFractionDigits = 1
		leftAxisFormatter.negativeSuffix = " g"
		leftAxisFormatter.positiveSuffix = " g"
		
		let leftAxis = graph.leftAxis
		leftAxis.labelFont = .systemFont(ofSize: 10)
		leftAxis.labelCount = 5
		leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
		leftAxis.labelPosition = .outsideChart
		leftAxis.spaceTop = 0.15
		leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
		
		// Turns off the right y-axis labels
		let rightAxis = graph.rightAxis
		rightAxis.enabled = false
		
		// Animation upon opening
		graph.animate(xAxisDuration: 1)
		
		reloadGraphData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadGraphData()
	}
	
	func reloadGraphData() {
		//TODO get meals to display
		DispatchQueue.main.async {
			autoreleasepool {
				let realm = try! Realm()
				
				//TODO get all meals, or filter by date & range
				let mealResults = realm.objects(Meal.self)
				var meals = [Meal]()
				meals.append(contentsOf: mealResults)

				//TODO get cachedFoodItems for reloadData. get all, or filter by desired foodId's
				let cachedFoodItemResults = realm.objects(CachedFoodItem.self)
				var cachedFoodItems = [CachedFoodItem]()
				cachedFoodItems.append(contentsOf: cachedFoodItemResults)
				
				self.reloadGraphData(meals, cachedFoodItems)
			}
		}
		

	}
			
	func getFoodItem(_ foodId: Int, _ cachedFoodItems: [CachedFoodItem]) -> CachedFoodItem? {
		for cached in cachedFoodItems {
			if cached.getFoodId() == foodId {
				return cached
			}
		}
		print("returned nil")
		return nil
	}
	
	func reloadGraphData(_ meals: [Meal], _ cachedFoodItems: [CachedFoodItem]) {
		let data = LineChartData() //This is the object that will be added to the chart
		let date = graphSettings.getDate() //use date to determine which meals to
		
		//construct graph data from saved meals, filtered by tags.
		for tag in self.DEFAULT_TAGS { //for each nutrient tag
			for meal in meals {
				var lineEntries = [ChartDataEntry]()
				
				var sum: Float = Float(0) //totol amount of nutrient
				for foodItem in meal.getFoodItems() { //TODO
					if let cached = self.getFoodItem(foodItem.getFoodId(), cachedFoodItems),
					let foodItemNutrient = cached.getFoodItemNutrient(tag)
					{
						let amount = foodItemNutrient.getAmount()
						sum = sum + amount // TODO scale by amount of food item
					}
				}
				
				let dayOfMonth = Calendar.current.ordinality(of: .day, in: .month, for: meal.getDate())!
				let entry = ChartDataEntry(x: Double(dayOfMonth), y: Double(sum))
				lineEntries.append(entry)
				
				
				let line = LineChartDataSet(values: lineEntries, label: "\(tag.name)")
				//set line color
				let colour:UIColor = randColor()
				line.setColor(colour)
				line.setCircleColor(colour)
				line.circleRadius = 4
				//line.drawCirclesEnabled = false
				data.addDataSet(line)

			}

		}
		
		// Set the date of the graph
		let dateFormatter = DateFormatter()
		//dateFormatter.setLocalizedDateFormatFromTemplate(graphSettings.dateFormat)
		let dateStr = dateFormatter.string(from: date)
		
		graph.data = data
		graph.notifyDataSetChanged()
		graph.chartDescription?.text = dateStr

		//TODO graph needs reload?
	}

	
	//AKN: https://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1
	func randColor() -> UIColor {
		let r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}
	
	
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

