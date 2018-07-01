//
//  GraphViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import RealmSwift
import Charts


class GraphSettings: Object {
	//MARK: Properties
	@objc var selectedDate = Date() //the date the graph should display. should default to current date and time.
	//@objc var dateFormat = ""
	//current date
	//unit
	//tags
	//MARK: Getters
	func getDate() -> Date {
		return selectedDate
	}
	//MARK: Setters
	//func setDate() {}
	
	
}

/** Controls graph behaviour & data **/
class GraphViewController: UIViewController {
	@IBOutlet weak var graph: LineChartView! //ref to view in the storyboard
	var graphSettings: GraphSettings? //if no settings found, use default settings & save
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
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
		
		//TESt print saved Meals
		let mealResults = realm.objects(Meal.self)
		print("num meals: \(mealResults.count)")
		
		//refresh graph after getting new data or updating settings.
		updateGraphData()
    }
	
	//update the data that should fill this graph.
	private func updateGraphData() {
		//TODO use different colors for each tag
//		let colors = [NSUIColor.red, NSUIColor.orange, NSUIColor.yellow, NSUIColor.green, NSUIColor.blue, NSUIColor.purple, NSUIColor.gray]
//		var colorCount = 0
		
		//Use graphSettings to determine how & what data should be displayed
		let date = graphSettings!.getDate()
		let data = LineChartData() //This is the object that will be added to the chart
		
		//get meals within desired timeframe
		let realm = try! Realm()
		let meals = realm.objects(Meal.self) //(get all meals for testing)
		let tags = [Nutrient.Name.TestBitterNutrientA, Nutrient.Name.TestBitterNutrientB] //TODO load tags from user settings
		
		//construct graph data
		for tag in tags { //for each tag
			var lineEntries = [ChartDataEntry]()
			for meal in meals { //for each meal
//				for foodItem in meal.getFoodItems() {
//					let dayOfMonth = Calendar.current.ordinality(of: .day, in: .month, for: meal.getDate())
					//let foodAmount = foodItem.getAmount() //TODO use getAmountOf(tag) instead
					//let nutrientAmount = foodItem.getAmountOf(nutrient: tag, fromFoodId: foodItem.getFoodId())
					//nutrientAmount += foodItem.getAmountOf(nutrient: tag, fromFoodId: foodItem.getFoodId())
//				}
				let dayOfMonth = Calendar.current.ordinality(of: .day, in: .month, for: meal.getDate())
				let nutrientAmount = meal.getAmountOf(nutrient: tag)
				let entry = ChartDataEntry(x: Double(dayOfMonth!), y: Double(nutrientAmount.getAmount()))
				lineEntries.append(entry)
			}
			let line = LineChartDataSet(values: lineEntries, label: "\(tag)")
			//line.colors = colors[colorCount]
			//colorCount += 1
			//if (colorCount == colors.count) {colorCount = 0 }
			data.addDataSet(line)
		}
		
		
		let dateFormatter = DateFormatter()
		//dateFormatter.setLocalizedDatFormatFromTemplate(graphSettings.dateFormat)
		let dateStr = dateFormatter.string(from: date)
		reloadGraph(data, dateStr)
	}
	
	private func reloadGraph(_ data: LineChartData, _ date: String) {
		graph.data = data
		graph.chartDescription?.text = date
	}

	
	//update a setting
	func updateGraphSettings() {
		//refresh graph for new settings
		updateGraphData()
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
	
	//TODO remove
	//for testing something - Amanda L
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
		
		print("added: " + foodItem.getName())
//		add food to food item list
		try! realm.write {
			foodItemList!.add(foodItem)
		}
	}
}
