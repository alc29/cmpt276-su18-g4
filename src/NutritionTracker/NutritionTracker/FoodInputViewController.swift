//
//  FoodInputViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit

class FoodInputViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	var meal = Meal()
	//var mealTableViewCells = [FoodItemTableViewCell]()
	@IBOutlet weak var mealTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		mealTableView.delegate = self
		mealTableView.dataSource = self
		
		//TEST
		meal.add(FoodItem(123124, "afasf"))
		meal.add(FoodItem(354654, "gdsdgs"))
		updateMealTable()
		
		mealTableView.register(FoodItemTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
	
	func saveMeal() {
		//realm
	}
	
	
	
	func addToMeal(_ foodItem: FoodItem) {
		meal.add(foodItem)
		addCell(foodItem)
	}
	
	//add cell to table
	func addCell(_ foodItem: FoodItem) {
		updateMealTable()
	}
	
	func updateMealTable() {
		mealTableView.beginUpdates()
		mealTableView.insertRows(at: [IndexPath(row: meal.count()-1, section: 0)], with: .automatic)
		mealTableView.endUpdates()
		mealTableView.reloadData()
	}
	
	func openSearchFoodItemSelector() {
		//add SearchViewController to stack
	}
	func openCatalogFoodItemSelector() {
		//add CatalogViewController to stack
	}
	
	// MARK: Table View Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	// Return the number of cells to display
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return meal.count()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let foodItem = meal.getFoodItems()[indexPath.row]
		let cellToUse = FoodItemTableViewCell(foodItem)
		cellToUse.textLabel!.text = foodItem.getName()
		return cellToUse
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
