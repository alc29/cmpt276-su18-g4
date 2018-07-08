//
//  MealBuilderViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit

class MealBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	// MARK: Properties
	@IBOutlet weak var mealTableView: UITableView!
	@IBOutlet weak var saveMealButton: UIButton!
	//var mealTableViewCells = [FoodItemTableViewCell]()
	var meal = Meal()

	// MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		mealTableView.delegate = self
		mealTableView.dataSource = self
		//mealTableView.register(MealBuilderTableViewCell.classForCoder(), forCellReuseIdentifier: "MealFoodItemCell")
		mealTableView.register(MealBuilderTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")

		//TEST
		meal.add(FoodItem(123124, "afasf"))
		meal.add(FoodItem(354654, "gdsdgs"))
		asyncReloadData()
		
		saveMealButton.isEnabled = meal.count() > 0
	}
	
	func asyncReloadData() {
		DispatchQueue.main.async {
			self.mealTableView.reloadData()
		}
	}
	
	func saveMeal() {
		//realm
	}
	
	func addToMeal(_ foodItem: FoodItem) {
		meal.add(foodItem)
		asyncReloadData()
		saveMealButton.isEnabled = true
	}
	
	//TODO add button in UITableViewCell to remove food item.
	func removeFromMeal(_ index: Int) {
		meal.remove(index)
		asyncReloadData()
		saveMealButton.isEnabled = meal.count() > 0
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
		
		var cell: UITableViewCell
		//MealFoodItemCell
		if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MealFoodItemCell", for: indexPath) as UITableViewCell! {
			cell = reuseCell
		} else {
			cell = MealBuilderTableViewCell(foodItem)
		}

		cell.textLabel!.text = foodItem.getName()
		return cell
	}
	
//	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//		if editingStyle == .delete {
//			removeFromMeal(indexPath.row)
//		}
//	}
	

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			self.removeFromMeal(indexPath.row)
			success(true)
		})
		return UISwipeActionsConfiguration(actions: [action])
	}
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .destructive, title: "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			self.removeFromMeal(indexPath.row)
			success(true)
		})
		//action.backgroundColor = .red
		return UISwipeActionsConfiguration(actions: [action])
	}

	
	/*
	func insertRow
	func deleteRow(_ indexPath: IndexPath) {
	mealTableView.beginUpdates()
	//mealTableView.insertRows(at: [IndexPath], with: UITableViewRowAnimation.automatic)
	//mealTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
	mealTableView.endUpdates()
	mealTableView.reloadData()
	}
	*/
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
