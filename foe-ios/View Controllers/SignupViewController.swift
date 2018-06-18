//
//  SignupViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextView: LabeledOutlineTextView!
    @IBOutlet weak var emailTextView: LabeledOutlineTextView!
    @IBOutlet weak var passwordTextView: LabeledOutlineTextView!
    @IBOutlet weak var reenteredPasswordTextView: LabeledOutlineTextView!
    
    var tvs : [LabeledOutlineTextView] = []
    
    var activeTextField : UITextField?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tvs += [nameTextView, emailTextView, passwordTextView, reenteredPasswordTextView]
        for item in tvs {
            print("inited")
            let currentTextView = item as LabeledOutlineTextView?
            let textField = currentTextView!.getTextField()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
