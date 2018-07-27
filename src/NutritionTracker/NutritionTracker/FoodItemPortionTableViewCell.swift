//
//  FoodItemPortionTableViewCell.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit

class FoodItemPortionTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var foodNameLabel: UILabel!

	var foodItem: FoodItem?
	static let dict = [Unit.G : [],
					   Unit.MG : [],
					   Unit.IU : [],
					   ]
	static let pickerData = ["a", "b", "c"]
	
	
	func initPicker() {
		picker.delegate = self
		picker.dataSource = self
		picker.layer.borderColor = UIColor.black.cgColor
		picker.layer.borderWidth = 1
		
		foodNameLabel.text = foodItem!.getName()
		self.backgroundColor = UIColor.white

		//TODO init picker values based on measures
		
		self.reloadInputViews()
		picker.reloadAllComponents()
	}

	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return FoodItemPortionTableViewCell.pickerData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return FoodItemPortionTableViewCell.pickerData[row]
	}
	
//		//set row height
//		func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//			return 20.0
//		}
//
//		//set component width
//		func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//			return 242.0
//		}
	
//	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//	}

//	override func setSelected(_ selected: Bool, animated: Bool) {
//		print("set selected")
//	}
//
//	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//		print("set hilighted")
//	}
	
}
