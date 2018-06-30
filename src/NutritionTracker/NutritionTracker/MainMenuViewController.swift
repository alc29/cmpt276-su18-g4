//
//  MainMenuViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import RealmSwift

class MainMenuViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        //print items in the persistent food item list
		let realm = try! Realm()
		let results = realm.objects(FoodItemList.self)
		if (results.count == 0) {
			print("no list yet")
		} else {
			let foodItemList: FoodItemList! = results.first
			print("items in list: \(foodItemList.count())")
		}
		
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("segue")
		if (segue.identifier == "MainMenuToGraph") {
			print("segue detected")
			let vc:GraphViewController = segue.destination as! GraphViewController

			//test passing a food item to the graph
			let foodItem = FoodItem(12345, "Noodles")
			vc.receiveTestFoodItem(foodItem: foodItem)
		}
	}

}
