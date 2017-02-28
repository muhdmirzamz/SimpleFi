//
//  HomeTableViewController.swift
//  SimpleTodo
//
//  Created by Muhd Mirza on 22/10/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchResultsUpdating {
	// making this an outlet does not work
	// you have to init and set it to nav bar
	var moreButton: UIBarButtonItem?
	var searchController: UISearchController?
	
	var userAction = UserAction()
	var validator = Validator()
	var uiHelper = UIHelper()
	var itemsArray = [NSManagedObject]()
	var filteredItemsArray = [NSManagedObject]()
	
	var level = 0
	var filePath = "/"
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.moreButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_more_horiz_white"), style: .plain, target: self, action: #selector(pullupActionSheet(addBtn:)))
		self.navigationItem.rightBarButtonItem = self.moreButton
		
		self.clearsSelectionOnViewWillAppear = true
		
		self.searchController = UISearchController.init(searchResultsController: nil)
		self.searchController?.searchResultsUpdater = self
		self.searchController?.dimsBackgroundDuringPresentation = false
		self.searchController?.definesPresentationContext = true
		self.tableView.tableHeaderView = self.searchController?.searchBar
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.itemsArray = self.userAction.fetchRequest(WithFilePath: self.filePath, AndLevel: self.level)
		self.tableView.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: action methods
	
	func pullupActionSheet(addBtn: UIBarButtonItem) {
		let alertController = UIAlertController.init(title: "Add", message: "", preferredStyle: .actionSheet)
		let addFolderAction = UIAlertAction.init(title: "Add folder", style: .default) { (action: UIAlertAction) in
			self.addFolder()
		}
		let addItemAction = UIAlertAction.init(title: "Add file", style: .default) { (action: UIAlertAction) in
			self.addFile()
		}
		let editAction = UIAlertAction.init(title: "Edit", style: .default) { (action: UIAlertAction) in
			self.moreButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.exitEditMode))
			self.navigationItem.rightBarButtonItem = self.moreButton
			
			self.tableView.setEditing(true, animated: true)
		}
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
		
		alertController.addAction(addFolderAction)
		alertController.addAction(addItemAction)
		alertController.addAction(editAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	func addFolder() {
		let alertController = UIAlertController.init(title: "Add Folder", message: "Enter folder name", preferredStyle: .alert)
		alertController.addTextField(configurationHandler: nil)
		let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action: UIAlertAction) in
			if let itemEntry = alertController.textFields?[0].text {
				if self.validator.item(Named: itemEntry, HasDuplicateInArray: self.itemsArray) {
					self.uiHelper.displayAlertWith(errorMsg: "There is already an existing folder", InViewController: self)
				} else if itemEntry.isEmpty {
					self.uiHelper.displayAlertWith(errorMsg: "You cannot leave the field blank", InViewController: self)
				} else {
					self.itemsArray = self.userAction.addItem(WithName: itemEntry, AndLevel: self.level, AndIsFolder: true, AtFilePath: self.filePath, Into: self.itemsArray)
					self.tableView.reloadData()
				}
			}
		}
		
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
		alertController.addAction(cancelAction)
		alertController.addAction(okAction)
		
		self.present(alertController, animated: true, completion: nil)
	}

	func addFile() {
		let alertController = UIAlertController.init(title: "Add Item", message: "Enter item name", preferredStyle: .alert)
		alertController.addTextField(configurationHandler: nil)
		let okAction = UIAlertAction.init(title: "Ok", style: .default) { (action: UIAlertAction) in
			if let itemEntry = alertController.textFields?[0].text {
				if self.validator.item(Named: itemEntry, HasDuplicateInArray: self.itemsArray) {
					self.uiHelper.displayAlertWith(errorMsg: "There is already an existing entry", InViewController: self)
				} else if itemEntry.isEmpty {
					self.uiHelper.displayAlertWith(errorMsg: "You cannot leave the field blank", InViewController: self)
				} else {
					self.itemsArray = self.userAction.addItem(WithName: itemEntry, AndLevel: self.level, AndIsFolder: false, AtFilePath: self.filePath, Into: self.itemsArray)
					self.tableView.reloadData()
				}
			}
		}
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
		alertController.addAction(cancelAction)
		alertController.addAction(okAction)
		
		self.present(alertController, animated: true, completion: nil)
	}

	func exitEditMode() {
		self.tableView.setEditing(false, animated: true)
		
		self.moreButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_more_horiz_white"), style: .plain, target: self, action: #selector(pullupActionSheet(addBtn:)))
		self.navigationItem.rightBarButtonItem = self.moreButton
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		if (self.searchController?.isActive)! && self.searchController?.searchBar.text?.isEmpty == false {
			return self.filteredItemsArray.count
		}
		
		return self.itemsArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		if (self.searchController?.isActive)! && self.searchController?.searchBar.text?.isEmpty == false {
			if let item = self.filteredItemsArray[indexPath.row] as? Item {
				if item.isFolder == true {
					cell.textLabel?.text = item.name!
					cell.accessoryType = .disclosureIndicator
					cell.imageView?.image = UIImage.init(named: "ic_folder_open")
				} else {
					cell.textLabel?.text = item.name
				}
			}
		} else {
			if let item = self.itemsArray[indexPath.row] as? Item {
				if item.isFolder == true {
					cell.textLabel?.text = item.name!
					cell.accessoryType = .disclosureIndicator
					cell.imageView?.image = UIImage.init(named: "ic_folder_open")
				} else {
					cell.textLabel?.text = item.name
				}
			}
		}
		
		return cell
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let item = self.itemsArray[indexPath.row] as? Item {
				self.userAction.delete(item: item)
				
				self.itemsArray = self.userAction.fetchRequest(WithFilePath: self.filePath, AndLevel: self.level)
				
				self.tableView.reloadData()
			}
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let row = self.tableView.indexPathForSelectedRow?.row {
			if let item = self.itemsArray[row] as? Item {
				if item.isFolder {
					let htvc = self.storyboard?.instantiateViewController(withIdentifier: "HomeTableViewController") as? HomeTableViewController
					
					// make sure each vc keeps track of its own variable
					// incrementing before setting means you are incrementing the current vc variable
					// this results in incorrect value for current vc
					htvc?.level = self.level + 1
					htvc?.filePath = self.filePath + item.name! + "/"
					htvc?.title = item.name!
					
					self.navigationController?.pushViewController(htvc!, animated: true)
				} else {
					let fileVC = self.storyboard?.instantiateViewController(withIdentifier: "FileViewController") as? FileViewController
					
					fileVC?.title = item.name!
					fileVC?.item = item
					fileVC?.itemsArray = self.itemsArray
					
					self.navigationController?.pushViewController(fileVC!, animated: true)
				}
			}
		}
	}
	
	public func updateSearchResults(for searchController: UISearchController) {
		self.filteredItemsArray = self.itemsArray.filter{items in
			let convertedItems = items as? Item
			
			let convertedItemName = (convertedItems?.name?.lowercased())!
			
			return (convertedItemName.contains(searchController.searchBar.text!.lowercased()))
		}

		
		self.tableView.reloadData()
	}
}
