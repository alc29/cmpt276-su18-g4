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
	@IBOutlet weak var graph: LineChartView! //ref to view in the storyboard
	var graphSettings: GraphSettings? //if no settings found, use default settings & save
	
    override func viewDidLoad() {
        super.viewDidLoad()
		initGraphAppearanceSettings()
		
		//get settings from realm, if none create new & add to realm.
		let realm = try! Realm()
		let results = realm.objects(GraphSettings.self)
		if (results.count == 0) {
			//create new settings instance
			let newSettings = GraphSettings()
			try! realm.write {
				realm.add(newSettings)
			}
			self.graphSettings = newSettings //save ref to settings
		} else {
			self.graphSettings = results.first //load graph settings from realm
		}
		assert(self.graphSettings != nil)
		
		//refresh graph after getting new data or updating settings.
		updateGraphData()
    }
	
	//update the data that should fill this graph.
	private func updateGraphData() {
		let data = LineChartData() //This is the object that will be added to the chart
		
		//get meals within desired timeframe
		let realm = try! Realm()
		let date = graphSettings!.getDate() //use date to determine which meals to 
		let meals = realm.objects(Meal.self) //(get all meals for testing)
		let tags = [Nutrient.TestBitterNutrientA, Nutrient.TestBitterNutrientB] //TODO load tags from user settings
		
		//construct graph data from saved meals, filtered by tags.
		for tag in tags { //for each tag
			var lineEntries = [ChartDataEntry]() //array for saving data to be plotted on a line.
			for meal in meals { //for each meal
				//determine date of meal
				let dayOfMonth = Calendar.current.ordinality(of: .day, in: .month, for: meal.getDate())
				//determine the amount of the nutrient
				let nutrientAmount = meal.getAmountOf(nutrient: tag)
				//create point on the graph & add to array
				let entry = ChartDataEntry(x: Double(dayOfMonth!), y: Double(nutrientAmount.getAmount()))
				lineEntries.append(entry)
			}
			//create new line plot
			let line = LineChartDataSet(values: lineEntries, label: "\(tag.name)")
			
			//TODO set random line color
			data.addDataSet(line)
		}
		
		// Set the date of the graph
		let dateFormatter = DateFormatter()
		//TODO dateFormatter.setLocalizedDatFormatFromTemplate(graphSettings.dateFormat)
		let dateStr = dateFormatter.string(from: date)
		
		reloadGraph(data, dateStr)
	}
	
	// Refresh the grpah
	private func reloadGraph(_ data: LineChartData, _ date: String) {
		graph.data = data
		graph.notifyDataSetChanged()
		graph.chartDescription?.text = date
	}
	
	//update a setting
	func updateGraphSettings() {
		//refresh graph for new settings
		updateGraphData()
	}
	
	//AKN: https://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1
	func randColor() -> UIColor {
		let r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}
	
	// Modify the graph's appearance.
	func initGraphAppearanceSettings() {
		//TODO
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	//TODO remove when finished
	//Testing - receive a food item from the previous MainMenu view.
	func receiveTestFoodItem(foodItem: FoodItem) {
		//Load existing, or create new FoodItemList
		//retrieve food list from realm
		let realm = try! Realm()
		let foodItemLists = realm.objects(FoodItemList.self)
		
		var foodItemList: FoodItemList?
		//if no list, make new one
		if (foodItemLists.count == 0) {
			try! realm.write {
				foodItemList = FoodItemList()
				realm.add(foodItemList!)
			}
		} else {
			foodItemList = foodItemLists.first
		}
		
		assert(foodItemList != nil)
		
		//print("added: " + foodItem.getName())
		//add food to food item list
		try! realm.write {
			foodItemList!.add(foodItem)
		}
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

