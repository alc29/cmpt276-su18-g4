//
//  EntryViewController.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-06-24.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit
import RealmSwift

class EntryViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//clear all persistent data from the last test run.
		clearRealmData()
	}
	
	private func clearRealmData() {
		let realm = try! Realm()
		try! realm.write {
			realm.deleteAll()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

