//
//  ViewController.swift
//  SlidingAlertViewController
//
//  Created by Pierre Liebenberg on 7/16/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showAlert(_ sender: Any) {
        
        var alertAttributes = [SlidingAlertViewController.SlidingAlertAttributes: Any]()
        alertAttributes.updateValue(UIImage(named: "AlertTertiaryActionIcon") as Any, forKey: .tertiaryButtonImage)
        alertAttributes.updateValue("Library Card Expired", forKey: .title)
        alertAttributes.updateValue("HKD99DK03", forKey: .subtitle)
        alertAttributes.updateValue("Looks like your library card has expired. In order to place a hold on this title, you'll need to renew your library card.", forKey: .description)
        alertAttributes.updateValue(UIColor.red, forKey: .tintColor)
        alertAttributes.updateValue(CGFloat(8), forKey: .primaryButtonCornerRadius)
        
        let alertController = SlidingAlertViewController()
        
        // Important: alertController's delegate should be set immediately after instantiation in order to populate it with alert content
        alertController.delegate = self
        
        alertController.attributes = alertAttributes
        
        alertController.alertPrimaryAction = {
            print("Primary action performed.")
            alertController.dismissAlertViewController()
        }
        
        alertController.alertSecondaryAction = {
            print("Secondary action performed.")
        }
        
        alertController.alertTertiaryAction = {
            print("Tertiary action performed.")
        }
        
        self.addChildViewController(alertController)
        
        self.view.addSubview(alertController.view)
        alertController.didMove(toParentViewController: self)
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        alertController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        alertController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        alertController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        print("Clicked.")
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ViewController: SlidingAlertViewControllerDelegate {
    
    func alertViewControllerDidDisappear(alertViewController: SlidingAlertViewController) {
        print("Alert dismissed.")
    }
    
    
}




























