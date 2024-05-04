//
//  SignUPVC.swift
//  QuickCutsAdminApp
//
//  Created by Akshat Gulati on 04/05/24.
//

import UIKit

class SignUPVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad() }

    
    @IBAction func SignUpDidTapped(_ sender: Any) { GoToHomeVC()
    }
    @IBAction func alreadyAMemberDidTapped(_ sender: Any) {
        
            navigationController?.popViewController(animated: true)
    }
}
