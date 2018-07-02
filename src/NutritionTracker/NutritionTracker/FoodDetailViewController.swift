//
//  FoodDetailViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-02.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController {
	@IBOutlet weak var foodName: UILabel!
	@IBOutlet weak var foodDescription: UILabel!
	var foodItem: FoodItem? {
		didSet { configureView() }
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
    }

	func configureView() {
		if let foodItem = foodItem {
			if let foodName = foodName, let foodDescription = foodDescription {
				foodName.text = foodItem.getName()
				foodDescription.text = "TODO descripe food nutrients"
				title = "TODO Food Item Detail Title"
			}
		}
	}
	

}
