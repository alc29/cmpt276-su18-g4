//
//  GraphViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import RealmSwift

class GraphViewController: UIViewController {
	var foodItemList: FoodItemList?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//Load existing, or create new FoodItemList

		//retrieve food list from realm
		let realm = try! Realm()
		let foodItemLists = realm.objects(FoodItemList.self)

		//if no list, make new one
		if (foodItemLists.count == 0) {
			try! realm.write {
				self.foodItemList = FoodItemList()
				realm.add(foodItemList!)
			}
		} else {
			let foodItemList = FoodItemList()
			self.foodItemList = foodItemList;
		}

		assert(foodItemList != nil)
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
	
	
	func receiveTestFoodItem(foodItem: FoodItem) {
		print("added: " + foodItem.getName())
//		add food to food item list
		self.foodItemList!.add(foodItem)
	}
}
