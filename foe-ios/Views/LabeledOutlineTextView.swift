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
    @IBInspectable var isSecure: Bool = false
    @IBInspectable var index: Int = 0
    
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
        inputTextField.isSecureTextEntry = isSecure
        inputTextField.tag = index
        self.tag = index
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView = view
    }
    
    func getTextField() -> UITextField {
        return inputTextField
    }
    
    func getText() -> String {
        return inputTextField.text!
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
        
        // Try to find next responder
        if let nextField = self.superview?.viewWithTag(textField.tag + 1) as? LabeledOutlineTextView {
            nextField.getTextField().becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField?.resignFirstResponder()
        renderInputActiveState(isActive: false)
    }
    
    // MARK: - Actions
    
    @IBAction func editingDidBegin(_ sender: Any) {
        renderInputActiveState(isActive: true)
    }
    
}
