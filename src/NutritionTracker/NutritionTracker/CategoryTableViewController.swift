//
//  CategoryTableViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//
//	View controller for the Category page.
//	The user can browse the catelog, and select foods based on a food group or other category.
//	When a category is selected, the view will display a list of foods within that category.
//	When a food item is selected, the View will present a detail page, for displaying information about the chosen item.
//	TODO rename

import UIKit

class CategoryTableViewController: UITableViewController {
	// MARK: Properties
	private let defaultFoodGroups = [FoodGroup.Dairy_and_Egg_Products,
									 FoodGroup.Snacks,
									 FoodGroup.Beverages,
									 FoodGroup.Vegetables]
	var foodGroups = [FoodGroup]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		foodGroups = defaultFoodGroups
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryCell")

    }
	
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

	// Return the number of cells to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodGroups.count
    }
	
	// Called when a cell is tapped. dipslay a table view of the list of foods
	// corresponding to the food group that was tapped.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//let foodGroupId = foodGroups[indexPath.row].getIdStr()
		//DatabaseWrapper.sharedInstance.getFoodItemsFrom(foodGroupId, handleFoodGroupItemsQuery)
		//TODO get food items from food group
		
		if let indexPath = tableView.indexPathForSelectedRow {
			
			//present sample food items in the food group
			var foodItems = [FoodItem]()
			foodItems.append(FoodItem(123, "afasfsa"))
			let vc = FoodListTableViewController()
			vc.foodItems = foodItems
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	//Display each cell as a FoodGroup
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel!.text = foodGroups[indexPath.row].name
		return cell
	}
	
	
//	func handleFoodGroupItemsQuery(_ data: Data?) {
//		if (data != nil) {
//			let foodItemResults = DatabaseWrapper.sharedInstance.jsonToFoodItems(data!)
//			let vc = FoodListTableViewController()
//			vc.foodItems = foodItemResults
//			self.navigationController!.pushViewController(vc, animated: true)
////			DispatchQueue.main.async {
////				self.tableView.reloadData()
////			}
//		}
//	}
	


	
	
	
	// MARK: Provided template methods
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
