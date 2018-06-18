//
//  LabeledOutlineTextView.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

@IBDesignable class LabeledOutlineTextView: UIView, UITextFieldDelegate {

    // MARK: - Outlets
    var contentView: UIView?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outline: UIView!
    
    var activeTextField : UITextField?
    
    // MARK: - Inspectables
    @IBInspectable var labelText : String = "Label"
    @IBInspectable var inputPlaceholderText : String = "Enter here"
    @IBInspectable var nibName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialize()
        contentView?.prepareForInterfaceBuilder()
    }
    
    private func initialize () {
    
        guard let view = loadViewFromNib() else { return }
        label.text = labelText
        inputTextField.placeholder = inputPlaceholderText
        inputTextField.delegate = self
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    func renderInputActiveState(isActive: Bool) {
        let color : UIColor = isActive ? UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0) : UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        
        UIView.transition(with: self.label, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.label.textColor = color
        }, completion: nil)
        
        UIView.transition(with: self.outline, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.outline.backgroundColor = color
        }, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        renderInputActiveState(isActive: false)
        activeTextField?.resignFirstResponder()
        print("here")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField?.resignFirstResponder()
        renderInputActiveState(isActive: false)
        print("callled here")
    }
    
    // MARK: - Actions
    
    @IBAction func editingDidBegin(_ sender: Any) {
        renderInputActiveState(isActive: true)
        print("went here!")
    }
    
}
