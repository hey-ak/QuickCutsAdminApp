import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

class SignUPVC: UIViewController {
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func SignUpDidTapped(_ sender: Any) {
        handleSignUP(emailTextField.text,
                     passwordTextField.text,
                     nameTextField.text,
                     locationTextField.text)
    }
    
    @IBAction func alreadyAMemberDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleSignUP(_ email:String?,
                              _ password:String?,
                              _ name:String?,
                              _ location:String?) {
        
        let data = ValidatableData(email: email,
                                   name: name,
                                   password: password,
                                   location: location)
        
        let validatedData = Validator.shared.validate(data: data)
        
        guard validatedData.errorType == nil else {
            guard let errorMessage = validatedData.errorMessage
            else { return }
            
            showToast(errorMessage)
            return
        }
        
        guard let email = validatedData.email,
              let password = validatedData.password else { return }
        
        handleFirebaseAuthentication(email,
                                     password,
                                     name,
                                     location)
    }
    
    private func handleFirebaseAuthentication(_ email:String,
                                              _ password:String,
                                              _ name:String?,
                                              _ location:String?) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { authResult, error in
            
            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                self.showToast(error)
                return }
            
            guard let authResult = authResult else { return }
            let authUser = authResult.user
            
            DispatchQueue.main.async {
                self.showToast("Account creatd sucessfully.")
                guard let name = name,let location = location else { return }
                guard let userLocation = LocationManager.shared.currentLocation?.coordinate else { return }
                
                let salon = SalonModel(id: authUser.uid,
                                       userType: 0,
                                       email: email,
                                       image: authUser.photoURL?.absoluteString,
                                       salonName: name,
                                       subTitle: "Best salon in town",
                                       about: "We offer a wide range of services...",
                                       address: location,
                                       rating: 1.0,
                                       reviews: 0,
                                       latitude: userLocation.latitude,
                                       longitude: userLocation.longitude,
                                       openDays: self.createOpenDays(),
                                       openingTime: Date(),
                                       closingTime: Date(),
                                       services: nil)
                
                AppDataManager.shared.createUserProfile(authUser.uid, salon)
                AppDataManager.shared.saveLoggedUserID(authUser.uid)
                AppDataManager.shared.saveUserProfile(salon)
                GoToHomeVC()
            }
        }
    }
    
    private func createOpenDays() -> [OpenDays] {
        var openDays: [OpenDays] = []
        for dayNumber in 1...7 {
            let openDay = OpenDays(id: dayNumber, dayNumber: dayNumber)
            openDays.append(openDay)
        }
        return openDays
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
