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
	var graphSettings = GraphSettings() //if no settings found, use default settings & save
	let DEFAULT_TAGS = [Nutrient.Sugars_total, Nutrient.Calcium, Nutrient.Sodium] //TODO load tags from graph settings
	var nutrientTags = [Nutrient]()
	var nutrients = [Nutrient]()
	var selected = [Bool]()
	
	@IBOutlet weak var graph: LineChartView! //ref to view in the storyboard
	@IBOutlet weak var nutrientTable: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//todo load graphs settings from realm
		for t in DEFAULT_TAGS {
			nutrientTags.append(t)
		}
		
		/* Nutrient Table */
		for (id, nutrient) in Nutrient.dict {
			if (id != -1 && id != -2) {
				nutrients.append(nutrient)
			}
		}
		selected = Array(repeating: false, count: nutrients.count)
		nutrientTable.delegate = self
		nutrientTable.dataSource = self
		self.nutrientTable.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "NutrientCell")
		
		
		/* Graph */
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
	
	func reloadGraphData(_ meals: [Meal], _ cachedFoodItems: [CachedFoodItem]) {
		let data = LineChartData() //This is the object that will be added to the chart
		let date = graphSettings.getDate() //use date to determine which meals to
		
		//construct graph data from saved meals, filtered by tags.
		for tag in nutrientTags { //for each nutrient tag
			for meal in meals {
				var lineEntries = [ChartDataEntry]()
				
				//add the total amount of the "tag" nutrient contained in the meal
				var sum: Float = Float(0)
				for foodItem in meal.getFoodItems() {
					if let cached = self.getFoodItem(foodItem.getFoodId(), cachedFoodItems),
						let foodItemNutrient = cached.getFoodItemNutrient(tag) {
						let amount = getTotalAmountOf(foodItemNutrient, foodItem)
						sum += amount
					}
				}
				
				//get days since jan 1
				let days = Calendar.current.ordinality(of: .day, in: .year, for: meal.getDate())!
				
				let entry = ChartDataEntry(x: Double(days), y: Double(sum))
				lineEntries.append(entry)
				
				let line = LineChartDataSet(values: lineEntries, label: "\(tag.name)")
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
		graph.chartDescription?.text = dateStr
		graph.notifyDataSetChanged()
	}
	
	func getFoodItem(_ foodId: Int, _ cachedFoodItems: [CachedFoodItem]) -> CachedFoodItem? {
		for cached in cachedFoodItems {
			if cached.getFoodId() == foodId {
				return cached
			}
		}
		//print("warning: GraphViewController::getFoodItem returned nil.")
		return nil
	}
	
	//returns in per 1 g
	func getTotalAmountOf(_ foodItemNutrient: FoodItemNutrient, _ foodItem: FoodItem) -> Float {
		
		//convert from per 100g to per 1g
		let nutrientAmount = foodItemNutrient.getAmount() / 100
		
		let foodAmount = foodItem.getAmount()
		
		let unit = foodItem.getUnit()
		
		//units should match those available in the UIPicker in FoodItemPortionTableViewCell
		if unit == Unit.G.rawValue {
			return nutrientAmount * foodAmount
			
		} else if (unit == Unit.MG.rawValue) {
			return nutrientAmount * foodAmount / 1000
			
		}
		
		//TODO handle other units
		return Float(0)
	}
	
	
	//AKN: https://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1
	func randColor() -> UIColor {
		let r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		let b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		return UIColor(red: r, green: g, blue: b, alpha: 1.0)
	}
	
}


extension GraphViewController: UITableViewDelegate, UITableViewDataSource {
	// MARK: - Table view data source
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nutrients.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientCell", for: indexPath)
		cell.textLabel?.text = nutrients[indexPath.row].name
		
		//set checkmark if selected
		if selected[indexPath.row] {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat(20.0)
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Nutrients"
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let cell = tableView.cellForRow(at: indexPath) {
			selected[indexPath.row] = !selected[indexPath.row] //toggle selection
			cell.accessoryType = selected[indexPath.row] ? .checkmark : .none
			
			//update nutrient tags
			setNutrient(nutrients[indexPath.row], selected[indexPath.row])
		}
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	//TODO move out of extension
	func setNutrient(_ nutrient: Nutrient, _ isSelected: Bool) {
		if isSelected { //add
			nutrientTags.append(nutrient)
		} else { //remove
			for (i, n) in nutrientTags.enumerated() {
				if n.getId() == nutrient.getId() {
					nutrients.remove(at: i)
					return
				}
			}
		}
		reloadGraphData()
	}
}



/** A class used for saving graph-related settings. */
class GraphSettings: Object {
	
	@objc var selectedDate = Date() //the date the graph should display when first loading.
	//@objc var dateFormat:
	//var unit = Unit.Micrograms // The unit that the graph should be displayed in.
	let tags = List<Nutrient>()
	
	convenience init(_ defaultTags: [Nutrient]) {
		self.init()
		tags.append(objectsIn: defaultTags)
	}
	
	
	func getDate() -> Date {
		return selectedDate
	}
	
}
