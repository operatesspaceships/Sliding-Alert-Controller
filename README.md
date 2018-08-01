# Sliding Custom Alert Controller
An animated alert controller for presenting customizable iOS alerts.

![sliding alert controller](https://user-images.githubusercontent.com/38790651/43541966-57ef2b72-9591-11e8-8632-57cd0923bfd8.gif)

# Usage
1. Drag SlidingAlertViewController.swift into your Xcode project.
2. The alert controller is instantiated and customized in code. In an alert- or error-handling function:
  * instantiate the alert controller,
  * set its delegate, attributes, and button actions,
  * add it as a child view controller,
  * and, finally, set its constraints.

# Example
```
// Customize alert controller's appearance and content
var alertAttributes = [SlidingAlertViewController.SlidingAlertAttributes: Any]()

alertAttributes.updateValue(UIImage(named: "AlertTertiaryActionIcon") as Any, forKey: .tertiaryButtonImage)
alertAttributes.updateValue("Library Card Expired", forKey: .title)
alertAttributes.updateValue("HKD99DK03", forKey: .subtitle)
alertAttributes.updateValue("Looks like your library card has expired. In order to place a hold on this title, you'll need to renew your library card.", forKey: .description)
alertAttributes.updateValue(UIColor.red, forKey: .tintColor)
alertAttributes.updateValue(CGFloat(8), forKey: .primaryButtonCornerRadius)

// Instantiate
let alertController = SlidingAlertViewController()

// Important: alertController's delegate should be set immediately after instantiation in order to populate it with alert content
alertController.delegate = self
alertController.attributes = alertAttributes

// Set up alert controller's actions
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

// Add alert controller to stack and set constraints
self.addChildViewController(alertController)

self.view.addSubview(alertController.view)
alertController.didMove(toParentViewController: self)

alertController.view.translatesAutoresizingMaskIntoConstraints = false
alertController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
alertController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
alertController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
alertController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
```

# Notes
* The `SlidingAlertAttributes` enum provides a list of customizable attributes. Default values are provided.
* The alert controller's delegate must conform to the `SlidingAlertViewControllerDelegate` protocol.
* This protocol requires implementing the `alertViewControllerDidDisappear(alertViewController: SlidingAlertViewController)` function in which you can place logic to run after the alert controller is dismissed.
