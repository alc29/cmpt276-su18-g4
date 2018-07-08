//
//  MainMenuViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//
//	ViewController for the main menu.
//	Transition logic is handled by segues in the storyboard.

import UIKit
import RealmSwift

class MainMenuViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		printList()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		printList()
	}
	
	// Testing - print the number of meals saved on the device.
	func printList() {
		let realm = try! Realm()
		let results = realm.objects(FoodItemList.self)
		if (results.count == 0) {
		} else {
			//let foodItemList: FoodItemList! = results.first
			//print("items in list: \(foodItemList.count())")
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	//Testing - pass a foodItem to the next view.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if (segue.identifier == "MainMenuToGraph") {
//			let vc:GraphViewController = segue.destination as! GraphViewController
//			//test passing a food item to the graph
//			let foodItem = FoodItem(12345, "Noodles")
//			vc.receiveTestFoodItem(foodItem: foodItem)
//		}
	}

}
