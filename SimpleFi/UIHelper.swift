//
//  UIHelper.swift
//  SimpleFi
//
//  Created by Muhd Mirza on 9/1/17.
//  Copyright © 2017 muhdmirzamz. All rights reserved.
//

import Foundation
import UIKit

public class UIHelper {
	func displayAlertWith(errorMsg msg: String, InViewController vc: UIViewController) {
		let alertController = UIAlertController.init(title: "Wait", message: msg, preferredStyle: .alert)
		let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
		alertController.addAction(okAction)
		vc.present(alertController, animated: true, completion: nil)
	}
}
