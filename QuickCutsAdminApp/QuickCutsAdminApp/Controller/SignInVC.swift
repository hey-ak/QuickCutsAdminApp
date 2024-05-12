import UIKit
import FirebaseAuth


class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dontHaveAccButtonTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUPVC") as! SignUPVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func forgotPassDidTapped(_ sender: Any) {
        handleForgotPass()
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        handleSignIN(emailTextField.text,
                     passwordTextField.text)
    }
    
    private func handleForgotPass() {
        Auth.auth().sendPasswordReset(withEmail: "sam@yopmail.com") { error in
            
            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                self.showToast(error)
                return }
            
            DispatchQueue.main.async {
                self.showToast("Forget Pass started.")
            }
        }
    }
    
    private func handleSignIN(_ email:String?,
                              _ password:String?) {
        
        let data = ValidatableData(email: email,
                                   name: "name",
                                   password: password,
                                   location: "Location")
        
        let validatedData = Validator.shared.validate(data: data)
        
        guard validatedData.errorType == nil else {
            guard let errorMessage = validatedData.errorMessage
            else { return }
            
            showToast(errorMessage)
            return
        }
        
        guard let email = validatedData.email,
              let password = validatedData.password else { return }
        
        handleFirebaseAuthentication(email, password)
    }
    
    private func handleFirebaseAuthentication(_ email:String,
                                              _ password:String) {
        
        
        Auth.auth().signIn(withEmail: email,
                           password: password) { user, error in
            
            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                self.showToast(error)
                return }
            
            DispatchQueue.main.async {
                self.showToast("Account logined in sucessfully.")
                guard let userId = user?.user.uid else { return }
                
                
                AppDataManager.shared.fetchUserProfile(for: userId) { result in
                    switch result {
                    case .success(let userProfile):
                        DispatchQueue.main.async {
                            self.showToast("Account logined in sucessfully.")
                            AppDataManager.shared.saveUserProfile(userProfile)
                            AppDataManager.shared.saveLoggedUserID(userId)
                            self.getUserData(userId)
                            GoToHomeVC()
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showToast(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func getUserData(_ saloneId:String) {
        FirebaseManager().getSalon(salonId: saloneId) { (salon, error) in
            guard error == nil else { return }
            let salon = salon
            print(salon)
        }
    }
    
    private func showToast(_ message:String) {
        DispatchQueue.main.async {
            let toast = Toast.default(
                image: UIImage(named: "mark")!,
                title: message
            )
            toast.show()
        }
    }
}
