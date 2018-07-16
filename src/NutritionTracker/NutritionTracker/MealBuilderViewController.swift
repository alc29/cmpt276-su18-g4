//
//  MealBuilderViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-30.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import RealmSwift

protocol FoodSelector {
	func addFood(foodItem: FoodItem)
}

class MealBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FoodSelector {
	// MARK: Properties
	@IBOutlet weak var mealTableView: UITableView!
	@IBOutlet weak var saveMealButton: UIButton!
	//var mealTableViewCells = [FoodItemTableViewCell]()
	var meal = Meal()
	var mealSavedAlertPopup:UIView?
	var mealSavedAlertLabel:UILabel = UILabel(frame: CGRect(x:100, y:400, width:200, height:50))

	// MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		 //TODO center label
		mealSavedAlertLabel.text = "Meal Saved"
		mealSavedAlertLabel.isHidden = true
		mealSavedAlertLabel.isUserInteractionEnabled = false
		mealSavedAlertLabel.backgroundColor = UIColor.black
		mealSavedAlertLabel.textColor = UIColor.white
		mealSavedAlertLabel.textAlignment = NSTextAlignment.center
		mealSavedAlertLabel.layer.cornerRadius = 4.0
		mealSavedAlertLabel.layer.masksToBounds = true
		self.view.addSubview(mealSavedAlertLabel)
		
		mealTableView.delegate = self
		mealTableView.dataSource = self
		mealTableView.register(MealBuilderTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")

		//TEST
		meal.add(FoodItem(45144608, "Poop candy"))
//		meal.add(FoodItem(354654, "gdsdgs"))
		asyncReloadData()
		
		saveMealButton.isEnabled = meal.count() > 0
	}
	
	//deselect selected cell, on returning to this view.
	override func viewWillAppear(_ animated: Bool) {
		if let selectionIndexPath = mealTableView.indexPathForSelectedRow {
			mealTableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
		super.viewWillAppear(animated)
	}
	
	//MARK: - Actions

	@IBAction func catalogButtonPressed(_ sender: UIButton) {
		let vc = CategoryTableViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	@IBAction func foodSearchButtonPressed(_ sender: UIButton) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let foodDetailView = storyboard.instantiateViewController(withIdentifier: "FoodDetailView") as! FoodDetailViewController
		let vc = storyboard.instantiateViewController(withIdentifier: "FoodSearchView") as! FoodSearchViewController
		vc.foodDetailViewController = foodDetailView
		
		let addButton = UIBarButtonItem(title: "Add", style: .plain, target: foodDetailView, action: #selector(foodDetailView.addButtonPressed(sender:)))
		foodDetailView.navigationItem.rightBarButtonItem = addButton
		foodDetailView.foodSelector = self
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
    
    @IBAction func visionButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foodDetailView = storyboard.instantiateViewController(withIdentifier: "FoodDetailView") as! FoodDetailViewController
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: foodDetailView, action: #selector(foodDetailView.addButtonPressed(sender:)))
        foodDetailView.navigationItem.rightBarButtonItem = addButton
        foodDetailView.foodSelector = self
		
		let foodSearchView = storyboard.instantiateViewController(withIdentifier: "FoodSearchView") as! FoodSearchViewController
		foodSearchView.foodDetailViewController = foodDetailView
        
        let visionController = storyboard.instantiateViewController(withIdentifier: "VisionView") as! ImageClassificationViewController
        //visionController.mealBuilder = self
        visionController.searchViewController = foodSearchView
        
        self.navigationController?.pushViewController(visionController, animated: true)
    }
	
	@IBAction func saveMealButtonPressed(_ sender: UIButton) {
		
		//TODO present portions screen; set amounts for each food item in the meal.
		
		//TODO meal date defaults to current day; add option button to set date.
		
		saveMeal(self.meal)
		saveMealButton.isEnabled = false
	}
	
	
	// MARK: - Functions
	
	// Save new Meal to list of user's meals
	func saveMeal(_ meal: Meal, _ debug: Bool = false) {
		let mealCopy = meal.clone()
		self.resetMeal()
		self.displayMealSavedAlert()
		
		//TODO cache nutrient info for each food item.
		
		for foodItem in mealCopy.getFoodItems() {
			let completion: (FoodReportV1?) -> Void = { (report: FoodReportV1?) -> Void in
				print("completion for: \(foodItem.getFoodId())")
			}
			
			//TODO request food report v1 & cache info.
			Database5.requestFoodReportV1(foodItem, completion)
		}
		
		DispatchQueue.main.async {
		//DispatchQueue(label: "background").async {
			let realm = try! Realm()
			try! realm.write {
				realm.add(mealCopy)
			}
		}
		
		
		//TODO
//		let completion: (FoodReportV2?) -> Void = { (report: FoodReportV2?) -> Void in
//			guard let report = report else {
//				print("MealBuilder: nil report received.")
//				return
//			}
//
//			//save meal to realm
//			let realm = try! Realm()
//			try!realm.write {
//				realm.add(mealCopy)
//				print("meal saved")
//			}
//		}
//		Database5.requestFoodReportV2(mealCopy, completion, false)
	}
	
	func displayMealSavedAlert() {
		mealSavedAlertLabel.isHidden = false
		mealSavedAlertLabel.alpha = 0.5
		UIView.animate(withDuration: 1.0, animations: { () -> Void in
			self.mealSavedAlertLabel.alpha = 0
			self.mealSavedAlertLabel.isHidden = true
		})
	}
	
	//replace current meal with new instance
	func resetMeal() {
		self.meal = Meal()
		asyncReloadData()
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
	
	func asyncReloadData() {
		DispatchQueue.main.async {
			self.mealTableView.reloadData()
		}
	}
	
	// MARK: - FoodSelector protocol
	func addFood(foodItem: FoodItem) {
		print("food selector: food added.")
		addToMeal(foodItem)
	}
	
	
	// MARK: - Table View Delegate
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
		//if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell! {
			cell = reuseCell
		} else {
			cell = MealBuilderTableViewCell(foodItem)
		}

		cell.textLabel!.text = foodItem.getName()
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let indexPath = tableView.indexPathForSelectedRow {
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoodDetailView") as! FoodDetailViewController
			vc.foodItem = meal.get(indexPath.row)!
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	// MARK: - Table View Swiping gestures
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
