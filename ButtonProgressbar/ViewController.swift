//
//  ViewController.swift
//  Test
//
//  Created by Chitaranjan Sahu on 10/01/20.
//  Copyright © 2020 Chitaranjan Sahu. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonComplete: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let line = CAShapeLayer()
    var progressCount:CGFloat = 0
    let formHeight:CGFloat = 60
    
    var activeFormNumber = 0
    
    
    var froms = [UIView]()
    let checkedImage = UIImage(named: "iconCellSelectedOn")! as UIImage
    let uncheckedImage = UIImage(named: "iconCellSelectedOff")! as UIImage
    let checkBox = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    typealias RSAlertAction = (UIAlertAction) -> Void


    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.checkBox.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.checkBox.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonComplete.bringSubviewToFront(view)
        generateFromView()
        buttonComplete.isEnabled = false
        buttonComplete.addCornerRadius(radius: 3)
    }
    
    func generateFromView() {
        generateFirstFormView()
    }
    
    func generateFirstFormView() {
        buttonComplete.setTitle("Select Delivery", for: .normal)
        generateForm()
        setUpStackView(.horizontal)
        for i in 0 ..< 2 {
            stackView.addArrangedSubview(getButtonConfig("Delivey address\(i)"))
        }
        
        addStackToViewHierarchy()
    }
    
    
    func generateSecondFrom() {
        buttonComplete.setTitle("Select Address", for: .normal)
        generateForm()
        setUpStackView(.vertical)
        stackView.clearSubviews()
        for i in 0 ..< 2 {
            stackView.addArrangedSubview(getButtonConfig("Address\(i)"))
        }
        addStackToViewHierarchy()
        
    }
    
    func generateThiredFrom() {
        buttonComplete.setTitle("Select Payment", for: .normal)
        generateForm()
        setUpStackView(.horizontal)
        stackView.clearSubviews()
        for i in 0 ..< 2 {
            if i == 0{
            stackView.addArrangedSubview(getButtonConfig("Credit Card"))
            }else {
              stackView.addArrangedSubview(getButtonConfig("Cash"))
            }
            
        }
        addStackToViewHierarchy()
    }
    
    func generateFourthForm() {
        buttonComplete.setTitle("Confirm aggrement", for: .normal)
        generateForm()
        setUpStackView(.horizontal,distribution: .fill)
        stackView.clearSubviews()
        checkBox.addTarget(self, action: #selector(buttonClickedEvent(_:)), for: .touchUpInside)
        isChecked = false
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.textColor = .black
        label.textAlignment = .left
        label.text = "I agree"
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.layoutSetWidth(50.0)
        checkBox.layoutSetHeight(50)
        stackView.addArrangedSubview(checkBox)
        stackView.addArrangedSubview(label)
        addStackToViewHierarchy()
    }
    
    
    
    private func generateForm() {
        froms.append(UIView())
        froms[activeFormNumber].frame = CGRect(x: buttonComplete.frame.origin.x, y: buttonComplete.frame.origin.y - 50, width: buttonComplete.bounds.width, height: formHeight)
        froms[activeFormNumber].backgroundColor = .clear
    }
    
    private func addStackToViewHierarchy() {
        self.froms[activeFormNumber].addSubview(stackView)
        self.view.addSubview(froms[activeFormNumber])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutAttachAll()
    }
    
    func setUpStackView(_ axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fillEqually) {
        for view in stackView.subviews {
            view.removeFromSuperview()
            stackView.removeArrangedSubview(view)
        }
        stackView.removeFromSuperview()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = distribution
        stackView.spacing = 8.0
    }
    
   
    
    private func getButtonConfig(_ title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        
        button.addTarget(self, action: #selector(moveForword(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = 5
        return button
    }
    
    @objc func buttonClickedEvent(_ sender: Any) {
        guard let _ = sender as? UIButton else {
            return
        }
        isChecked = !isChecked
        buttonComplete.setTitle("DoNe@", for: .normal)
        moveForword(sender)
        self.makeProgress()
        buttonComplete.isEnabled = true
    }
    
    
    @objc func moveForword(_ action: Any) {
        guard let button = action as? UIButton, let stackview = button.superview as? UIStackView,let supperview = stackview.superview else {
            return
        }
        
        let originalTransform = supperview.transform
        let scaledTransform = originalTransform
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: -50)
        UIView.animate(withDuration: 0.7, animations: {
            supperview.transform = scaledAndTranslatedTransform
            supperview.alpha = 0.0
        }) { (completed) in
            if self.activeFormNumber >= 3 {
                return
            }
            supperview.isHidden = true
            supperview.clearSubviews()
            self.activeFormNumber += 1
            if self.activeFormNumber == 1 {
                self.generateSecondFrom()
            }else if self.activeFormNumber == 2 {
                self.generateThiredFrom()
            }else {
                self.generateFourthForm()
            }
            
            self.makeProgress()
        }
    }
    
    private func makeProgress() {
        DispatchQueue.main.async {
            self.progressCount += 1
            UIView.animate(withDuration: 0.3) {
                self.progressBar.setProgress(Float((self.progressCount/4)), animated: true)
            }
        }
    }
    
    func drawLine() {
        let linePath = UIBezierPath()
        UIView.animate(withDuration: 0.5) {
            linePath.move(to: CGPoint(x: 100, y: 100))
            linePath.addLine(to: CGPoint(x: 300, y: 100))
            self.line.path = linePath.cgPath
            self.line.strokeColor = UIColor.red.cgColor
            self.view.layer.addSublayer(self.line)

        }
    }
    
    func removeLine() {
        line.removeFromSuperlayer()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
// on complete fill enable the button
        let alert = getSingleChoiceAlert(withTitle: "volla", withPrimaryActionTitle: "success")
        self.present(alert, animated: true, completion: nil)
    }
    
     func getSingleChoiceAlert(withTitle title: String,
                                     andMessage message: String = "",
                                     withPrimaryActionTitle primaryTitle: String,
                                     withPrimaryAction primaryAction: RSAlertAction? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let primaryAlertAction = UIAlertAction(title: primaryTitle, style: .default, handler: primaryAction)
        
        alertController.addAction(primaryAlertAction)
        return alertController
    }
    
}


extension UIView {
    // MARK: - Layout Utilities
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(to: UIView? = nil,
                         margin: CGFloat = 0.0) {
        let view = to ?? superview
        translatesAutoresizingMaskIntoConstraints = false
        layoutAttachTop(to: view, margin: margin)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view,
    @discardableResult
    func layoutAttachTop(to: UIView? = nil,
                         margin : CGFloat = 0.0) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .top,
                                            multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil,
                            margin : CGFloat = 0.0,
                            priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        return constraint
    }
    
    /// Set the height of the current view
    @discardableResult
    func layoutSetHeight(_ height: CGFloat,
                         priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: height)

        if let priority = priority {
            constraint.priority = priority
        }
        self.addConstraint(constraint)
        return constraint
    }
    
    /// Set the width of the current view
       @discardableResult
       func layoutSetWidth(_ width: CGFloat,
                           priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
           let constraint = NSLayoutConstraint(item: self,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               multiplier: 1.0,
                                               constant: width)
           if let priority = priority {
               constraint.priority = priority
           }
           self.addConstraint(constraint)
           return constraint
       }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil,
                             margin : CGFloat = 0.0) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: margin)
        superview?.addConstraint(constraint)
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil,
                              margin : CGFloat = 0.0,
                              priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let view: UIView? = to ?? superview
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .trailing,
                                            multiplier: 1.0,
                                            constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        return constraint
    }
    
    /// Remove All subviews
    func clearSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    
    // MARK: Adds the corner radius to the view
    /// - Parameter radius: radius you want to pass
    func addCornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
