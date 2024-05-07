//
//  SignInVC.swift
//  QuickCutsAdminApp
//
//  Created by Akshat Gulati on 04/05/24.
//

import UIKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        GoToHomeVC()
    }
    
    @IBAction func dontHaveAccButtonTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUPVC") as! SignUPVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
