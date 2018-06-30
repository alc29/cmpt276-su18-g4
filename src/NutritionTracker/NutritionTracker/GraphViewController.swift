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
	//date format
	//current date
	//unit
	//tags
}

/** Controls graph behaviour & data **/
class GraphViewController: UIViewController {
	@IBOutlet weak var graph: LineChartView!
	
	
	//TODO add graph settigns - tells graph what to display & how
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//refresh graph after getting new data or updating settings.
		updateGraphData()
    }
	
	
	//update the data that should fill this graph.
	func updateGraphData() {
		
		//TODO define xy values.
		var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
		var numbers: [Double] = []
		//here is the for loop
		for i in 0..<numbers.count {
			let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
			lineChartEntry.append(value) // here we add it to the data set
		}
		
		//TODO add more lines for different nutrients.
		let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
		line1.colors = [NSUIColor.blue] //Sets the colour to blue
		
		let data = LineChartData() //This is the object that will be added to the chart
		data.addDataSet(line1) //Adds the line to the dataSet
		
		let date = "TODO DATE STRING" //TODO get date to display (current date, or past date selected by user)
		
		reloadGraph(data, date)
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
