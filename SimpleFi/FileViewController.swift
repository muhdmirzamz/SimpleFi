//
//  FileViewController.swift
//  SimpleTodo
//
//  Created by Muhd Mirza on 3/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import UIKit
import CoreData

class FileViewController: UIViewController {

	@IBOutlet var filePathLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var nameTextView: UITextView!

	var item: Item?
	var userAction = UserAction()
	var validator = Validator()
	
	// to check every object in this array for duplicates
	var itemsArray = [NSManagedObject]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

		self.filePathLabel.text = self.item?.filePath!
		self.nameLabel.text = self.item?.name!
		self.nameTextView.isEditable = true
		self.nameTextView.text = ""

        // Do any additional setup after loading the view.
    }

	@IBAction func updateName() {
		let parentPath = self.validator.getParentPathSubstringOf(itemPath: (self.item?.filePath)!, withName: (self.item?.name)!)
		
		if self.validator.item(Named: self.nameTextView.text!, HasDuplicateInArray: self.itemsArray) {
			let alertController = UIAlertController.init(title: "Wait", message: "There is already an existing entry", preferredStyle: .alert)
			let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
			alertController.addAction(okAction)
			self.present(alertController, animated: true, completion: nil)
		} else if self.nameTextView.text!.isEmpty {
			let alertController = UIAlertController.init(title: "Wait", message: "You cannot leave the field blank", preferredStyle: .alert)
			let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
			alertController.addAction(okAction)
			self.present(alertController, animated: true, completion: nil)
		} else {
			// add it to the context
			let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: self.context) as? Item
			newItem?.filePath = parentPath + "\(self.nameTextView.text!)"
			newItem?.isFolder = (self.item?.isFolder)!
			newItem?.level = (self.item?.level)!
			newItem?.name = self.nameTextView.text!
			
			print("filePath: \((newItem?.filePath)!)")
			print("filePath: \((newItem?.name)!)")
			
			self.userAction.delete(item: item!)
			self.itemsArray = self.userAction.addItem(WithName: (newItem?.name)!, AndLevel: Int((newItem?.level)!), AndIsFolder: false, AtFilePath: (newItem?.filePath)!, Into: self.itemsArray)
			
			// update all the necessary labels
			self.filePathLabel.text = (newItem?.filePath)!
			self.nameLabel.text = (newItem?.name)!
			self.nameTextView.text = ""
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

}
