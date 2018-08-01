//
//  SlidingAlertController.swift
//  SlidingAlertViewController
//
//  Created by Pierre Liebenberg on 7/16/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import UIKit

public protocol SlidingAlertViewControllerDelegate {
    func alertViewControllerDidDisappear(alertViewController: SlidingAlertViewController)
}

@objcMembers
open class SlidingAlertViewController: UIViewController {
    
    // MARK: - Public Properties
    
    /**
    
     Use this enum to access and customize the alert controller's attributes. Default values are provided for all attributes.
     
    # Usage
    Declare an array of `SlidingAlertAttributes` and inject it into the SlideAlertController's `attributes` property.
     
    # Example
     ```
     var alertAttributes = [SlidingAlertViewController.SlidingAlertAttributes: Any]()
     
     alertAttributes.updateValue(UIImage(named: "AlertTertiaryActionIcon") as Any, forKey: .tertiaryButtonImage)
     alertAttributes.updateValue("Library Card Expired", forKey: .title)
     alertAttributes.updateValue("HKD99DK03", forKey: .subtitle)
     alertAttributes.updateValue("Looks like your library card has expired. In order to place a hold on this title, you'll need to renew your library card.", forKey: .description)
     alertAttributes.updateValue(UIColor.red, forKey: .tintColor)
     alertAttributes.updateValue(CGFloat(8), forKey: .primaryButtonCornerRadius)

     let alertController = SlidingAlertViewController()

     alertController.delegate = self
     alertController.attributes = alertAttributes
     ```
     
     The following attributes are included:
 
         .tintColor
         .cornerRadius
         .title
         .subtitle
         .description
         .titleColor
         .subtitleColor
         .descriptionColor
         .primaryButtonTitle
         .primaryButtonCornerRadius
         .secondaryButtonTitle
         .tertiaryButtonImage
     
     - Precondition: The `alertController`'s `delegate` should be set immediately after instantiation in order to populate the alert with content.
     
     */
    public enum SlidingAlertAttributes {
        case tintColor
        case cornerRadius
        case title
        case subtitle
        case description
        case titleColor
        case subtitleColor
        case descriptionColor
        case primaryButtonTitle
        case primaryButtonCornerRadius
        case secondaryButtonTitle
        case tertiaryButtonImage
    }

    open var delegate: SlidingAlertViewControllerDelegate?
    open var attributes: [SlidingAlertAttributes : Any]?
    open var alertPrimaryAction: (() -> ())?
    open var alertSecondaryAction: (() -> ())?
    open var alertTertiaryAction: (() -> ())?
    
    
    // MARK: - Private Properties
    private var overlay = UIView()
    private var alertCard = UIView()
    private var tertiaryButtonImage: UIImage? = UIImage()
    private var errorTitle = UILabel()
    private var errorReferenceNumber = UILabel()
    private var errorDescription = UILabel()
    private var primaryActionButton = UIButton()
    private var secondaryActionButton = UIButton()
    private var tertiaryActionButton = UIButton()
    
    
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override open func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        
        
        self.alertCard.updateConstraints()
        self.primaryActionButton.updateConstraints()
        self.errorTitle.updateConstraints()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideInAlertCard()
    }
    
    // MARK: - Setup
    private func setUp() {
        setUpOverlay()
        
    }
    
    private func setUpOverlay() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up overlay
        overlay = UIView(frame: self.view.frame)
        self.view.addSubview(overlay)
        
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlay.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        overlay.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        overlay.alpha = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAlertViewController))
        overlay.addGestureRecognizer(tapGestureRecognizer)
        
        setUpAlertCard()
    }
    
    private func setUpAlertCard() {
        // Set up alert card
        alertCard = UIView()
        self.view.addSubview(alertCard)
        
        alertCard.translatesAutoresizingMaskIntoConstraints = false
        alertCard.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        alertCard.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        alertCard.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        alertCard.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        alertCard.backgroundColor = .white
        alertCard.layer.cornerRadius = 33
        alertCard.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let distance = self.view.frame.maxY - alertCard.frame.minY
        alertCard.transform = CGAffineTransform(translationX: 0, y: distance)
        
        setUpAlertContent()
    }
    
    private func setUpAlertContent() {
        // Set up Error Title
        errorTitle = UILabel()
        alertCard.addSubview(errorTitle)
        
        errorTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        errorTitle.text = attributes?[.title] as? String ?? "Alert Title"
        errorTitle.textAlignment = .center
        
        errorTitle.translatesAutoresizingMaskIntoConstraints = false
        errorTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        errorTitle.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 60).isActive = true
        errorTitle.leftAnchor.constraint(equalTo: alertCard.leftAnchor).isActive = true
        errorTitle.rightAnchor.constraint(equalTo: alertCard.rightAnchor).isActive = true
        errorTitle.centerXAnchor.constraint(equalTo: alertCard.centerXAnchor).isActive = true
        
        // Set up Error Reference Number
        let errorReferenceNumber = UILabel()
        alertCard.addSubview(errorReferenceNumber)
        
        errorReferenceNumber.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        errorReferenceNumber.textColor = UIColor.lightGray
        errorReferenceNumber.text = attributes?[.subtitle] as? String ?? "Error Reference Number"
        errorReferenceNumber.textAlignment = .center
        
        errorReferenceNumber.translatesAutoresizingMaskIntoConstraints = false
        errorReferenceNumber.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorReferenceNumber.topAnchor.constraint(equalTo: errorTitle.bottomAnchor, constant: 10).isActive = true
        errorReferenceNumber.leftAnchor.constraint(equalTo: alertCard.leftAnchor).isActive = true
        errorReferenceNumber.rightAnchor.constraint(equalTo: alertCard.rightAnchor).isActive = true
        errorReferenceNumber.centerXAnchor.constraint(equalTo: alertCard.centerXAnchor).isActive = true
        
        // Set up Error Description
        let errorDescription = UILabel()
        alertCard.addSubview(errorDescription)
        
        errorDescription.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        errorDescription.textColor = .black
        errorDescription.numberOfLines = 0
        
        let errorDescriptionStyle = NSMutableParagraphStyle()
        errorDescriptionStyle.alignment = .center
        errorDescriptionStyle.firstLineHeadIndent = 30
        errorDescriptionStyle.headIndent = 30
        errorDescriptionStyle.tailIndent = -30
        errorDescriptionStyle.lineBreakMode = .byWordWrapping
        
        let errorDescriptionAttributedText = attributes?[.description] as? String ?? "The error description goes here. Sufficient Detail is encouraged but not necessarily required. As with everything, the execution is the purview of the implementer."
        let errorDescriptionAttributedString = NSAttributedString(string: errorDescriptionAttributedText, attributes: [NSAttributedStringKey.paragraphStyle: errorDescriptionStyle])
        errorDescription.attributedText = errorDescriptionAttributedString
        
        
        errorDescription.translatesAutoresizingMaskIntoConstraints = false
        errorDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        errorDescription.topAnchor.constraint(equalTo: errorReferenceNumber.bottomAnchor, constant: 15).isActive = true
        errorDescription.leftAnchor.constraint(equalTo: alertCard.leftAnchor).isActive = true
        errorDescription.rightAnchor.constraint(equalTo: alertCard.rightAnchor).isActive = true
        errorDescription.centerXAnchor.constraint(equalTo: alertCard.centerXAnchor).isActive = true
        
        setUpAlertSecondaryActionButton()
    }
    
    
    private func setUpAlertPrimaryActionButton() {
        primaryActionButton = UIButton(type: .system)
        alertCard.addSubview(primaryActionButton)
        
        primaryActionButton.backgroundColor = attributes?[.tintColor] as? UIColor ?? UIColor.red
        primaryActionButton.setTitleColor(UIColor.white, for: .normal)
        primaryActionButton.setTitle(attributes?[.primaryButtonTitle] as? String ?? "Okay", for: .normal)
        primaryActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        primaryActionButton.layer.cornerRadius = attributes?[.primaryButtonCornerRadius] as? CGFloat ?? 8
        
        primaryActionButton.translatesAutoresizingMaskIntoConstraints = false
        primaryActionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        primaryActionButton.bottomAnchor.constraint(equalTo: secondaryActionButton.topAnchor, constant: -5).isActive = true
        primaryActionButton.leftAnchor.constraint(equalTo: alertCard.leftAnchor, constant: 10).isActive = true
        primaryActionButton.rightAnchor.constraint(equalTo: alertCard.rightAnchor, constant: -10).isActive = true
        primaryActionButton.centerXAnchor.constraint(equalTo: alertCard.centerXAnchor).isActive = true
        
        primaryActionButton.addTarget(self, action: #selector(primaryAction), for: .touchUpInside)
    }
    
    private func setUpAlertSecondaryActionButton() {

        secondaryActionButton = UIButton(type: .system)
        alertCard.addSubview(secondaryActionButton)
        secondaryActionButton.backgroundColor = .clear
        secondaryActionButton.setTitleColor(attributes?[.tintColor] as? UIColor ?? UIColor.red, for: .normal)
        secondaryActionButton.setTitle(attributes?[.secondaryButtonTitle] as? String ?? "Learn More", for: .normal)
        secondaryActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        /*for state: UIControlState in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            secondaryActionButton.setTitle(NSLocalizedString("Title", comment: ""), for: state)
        }*/
        
        secondaryActionButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryActionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        secondaryActionButton.bottomAnchor.constraint(equalTo: alertCard.bottomAnchor, constant: -20).isActive = true
        secondaryActionButton.leftAnchor.constraint(equalTo: alertCard.leftAnchor, constant: 0).isActive = true
        secondaryActionButton.rightAnchor.constraint(equalTo: alertCard.rightAnchor, constant: 0).isActive = true
        
        secondaryActionButton.addTarget(self, action: #selector(secondaryAction), for: .touchUpInside)
        
        setUpAlertPrimaryActionButton()
        setUpAlertTertiaryActionButton()

    }
    
    private func setUpAlertTertiaryActionButton() {
        
        tertiaryActionButton = UIButton(type: UIButtonType.custom)
        alertCard.addSubview(tertiaryActionButton)
        tertiaryActionButton.backgroundColor = .clear
        
        tertiaryActionButton.setImage((attributes?[.tertiaryButtonImage] as? UIImage)?.withRenderingMode(.alwaysTemplate) ?? tertiaryButtonImage, for: .normal)
        tertiaryActionButton.imageView?.contentMode = .scaleToFill
        tertiaryActionButton.tintColor = attributes?[.tintColor] as? UIColor ?? UIColor.red
        
        tertiaryActionButton.titleLabel?.numberOfLines = 1
        tertiaryActionButton.clipsToBounds = false
        
        tertiaryActionButton.translatesAutoresizingMaskIntoConstraints = false
        tertiaryActionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tertiaryActionButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        tertiaryActionButton.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 10).isActive = true
        tertiaryActionButton.leftAnchor.constraint(equalTo: alertCard.leftAnchor, constant: 10).isActive = true
        
        tertiaryActionButton.addTarget(self, action: #selector(tertiaryAction), for: .touchUpInside)
        
    }
    
    private func slideInAlertCard() {
        
        UIView.animate(withDuration: 0.25, delay: 0, animations: { [unowned self] in
            
            self.overlay.alpha = 1
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.15, usingSpringWithDamping: 0.95, initialSpringVelocity: 1, options: [], animations: { [unowned self] in
            
            self.alertCard.transform = .identity
            
        }, completion: nil)
    
    }
    
    @objc private func slideOutAlertCard(completion: @escaping () -> ()) {
        let distance = self.view.frame.maxY - alertCard.frame.minY
        
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: [], animations: { [unowned self] in
            
            self.alertCard.transform = CGAffineTransform(translationX: 0, y: distance)
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.15, delay: 0.25, animations: { [unowned self] in
            
            self.overlay.alpha = 0.0
            
        }, completion: {_ in
            
            completion()
        })
    }
 
    func dismissAlertViewController() {
        slideOutAlertCard { [unowned self] in
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.delegate?.alertViewControllerDidDisappear(alertViewController: self)
            
        }
        
    }
    
    @objc private func primaryAction() {
        
        if let primaryAction = alertPrimaryAction {
            primaryAction()
        } else {
            dismissAlertViewController()
        }
        
    }
    
    @objc private func secondaryAction() {
        self.alertSecondaryAction!()
    }
    
    @objc private func tertiaryAction() {
        guard alertTertiaryAction != nil else { return }
        self.alertTertiaryAction!()
    }
    
    deinit {
        attributes = nil
        tertiaryButtonImage = nil
        primaryActionButton.removeFromSuperview()
        secondaryActionButton.removeFromSuperview()
        tertiaryActionButton.removeFromSuperview()
        tertiaryButtonImage = nil
        
    }

}

