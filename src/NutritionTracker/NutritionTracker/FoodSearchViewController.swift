//
//  FoodSearchViewController2.swift
//  NutritionTracker
//
//  Created by alc29 on 2018-07-02.
//  Copyright © 2018 alc29. All rights reserved.
//

import UIKit

/**
	Controls the search bar & search results displayed in the Search view.
	Passes a selected food to the FoodDetailViewController.
*/
class FoodSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	//MARK: Properties
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchFooter: SearchFooterView!
	
	var foodDetailController: FoodDetailViewController? = nil
	var results = [FoodItem]()
	var filteredResults = [FoodItem]()
	let searchController = UISearchController(searchResultsController: nil)
	
	//MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup search controller
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Foods"
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		//setup the scope bar
		searchController.searchBar.scopeButtonTitles = ["All", "Meat", "Vegges"]
		searchController.searchBar.delegate = self
		
		//setup search footer
		tableView.tableFooterView = searchFooter
		
		//fake list of results
		for i in 0..<10 {
			results.append(FoodItem(i, "Food item \(i)"))
		}
		//print("results: \(results.count)")
		
//		if let navigationController = navigationController {
//			let controllers = navigationController.viewControllers
//			foodDetailController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? FoodDetailViewController
//		}
    }

	override func viewWillAppear(_ animated: Bool) {
		if let selectionIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
		super.viewWillAppear(animated)
	}
	
	// MARK: = Table View
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering() {
			searchFooter.setIsFilteringToShow(filteredItemCount: filteredResults.count, of: results.count)
			return filteredResults.count
		}
		searchFooter.setNotFiltering()
		return results.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell!
		let foodItem: FoodItem
//		if isFiltering() {
//			foodItem = filteredResults[indexPath.row]
//		} else {
//			foodItem = results[indexPath.row]
//		}
		foodItem = results[indexPath.row]
		
		cell.textLabel!.text = foodItem.getName()
		cell.detailTextLabel!.text = "todo candy.category"
		return cell
	}
	
	//MARK: - Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		//Pass selected FoodItem to FoodDetailViweController
		if (segue.identifier == "selectFoodItem") {
			let foodDetailController: FoodDetailViewController = segue.destination as! FoodDetailViewController
			let foodItem: FoodItem
			if let indexPath = tableView.indexPathForSelectedRow {
				foodItem = results[indexPath.row]
				foodDetailController.foodItem = foodItem
			}
		}
	}
		
	
	//Mark: - private instance methods
	func filterContentForSearchText(_ searchText: String, scope: String = "All") {
		filteredResults = results.filter({(foodItem: FoodItem) -> Bool in
			//TODO implement if we want to filter results by a category (FoodGroup)
//			let doesCategoryMatch = (scope == "All") || (true) //|| (candy.category == scope)
//			if searchBarIsEmpty() {
//				return doesCategoryMatch
//			} else {
//				return doesCategoryMatch && foodItem.getName().lowercased().contains(searchText.lowercased())
//			}
			return true
		})
		tableView.reloadData()
	}
	func searchBarIsEmpty() -> Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	func isFiltering() -> Bool {
//		let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
//		return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
		return false
	}
	
}

extension FoodSearchViewController: UISearchBarDelegate {
	//MARK: - UISearchBar Delegate
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
	}
}

extension FoodSearchViewController: UISearchResultsUpdating {
	// MARK: - UISearchResultsUpdating Delegate
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		filterContentForSearchText(searchController.searchBar.text!, scope: scope)
	}
}
