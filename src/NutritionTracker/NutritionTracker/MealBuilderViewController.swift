//
//  MealBuilderViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit

class MealBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
		
		mealTableView.register(MealBuilderTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
	
	func saveMeal() {
		//realm
	}
	
	
	
	func addToMeal(_ foodItem: FoodItem) {
		meal.add(foodItem)
		addCell(foodItem)
	}
	
	//TODO add button in UITableViewCell to remove food item.
	func removeFromMeal(_ index: Int) {
		meal.remove(index)
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
	
	// AKN: https://medium.com/ios-os-x-development/enable-slide-to-delete-in-uitableview-9311653dfe2
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			meal.remove(indexPath.row)
			mealTableView.beginUpdates()
			mealTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
			mealTableView.endUpdates()
			mealTableView.reloadData()
		}
	}
	
	
//	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//		let action = UIContextualAction(style: .normal, title: "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//			print("Close")
//		})
//		return UISwipeActionsConfiguration(actions: [action])
//	}
//	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//		let action = UIContextualAction(style: .normal, title: "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//			print("Close")
//		})
//		return UISwipeActionsConfiguration(actions: [action])
//	}
	
	
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
