import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class AddServicesVC: UIViewController {
    

    @IBOutlet weak var serviceName: UITextField!
    @IBOutlet weak var servicePrice: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addServiceDidTapped(_ sender: Any) {
        handleAddService()
    }
    
    private func handleAddService() {
        guard let name = serviceName.text, !name.isEmpty else {
            showToast("Please enter a salone name.")
            return }
        
        guard let price = servicePrice.text, !price.isEmpty else {
            showToast("Please enter a salone name.")
            return }
        let timeStamp = Int((Date().timeIntervalSince1970) * 1000)
        let priceInDouble = Double(price)
        guard let priceInDouble = priceInDouble, priceInDouble > 0 else {
            showToast("Price can not be zero.")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let service = SalonServices(id: timeStamp,
                                    serviceImage: nil,
                                    serviceName: name,
                                    servicePrice: priceInDouble)
        
        fetchUserProfile(for: uid) { result in
            switch result {
            case .success(let userProfile):
                var salon = userProfile
                
                if salon.services == nil {
                    salon.services = [service]
                }
                else {
                    salon.services?.append(service)
                }

                self.updateUserProfile(for: uid, with: salon) { error in
                    DispatchQueue.main.async {
                        self.showToast("Service added secessfullu.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
 
            case .failure(let _):
                DispatchQueue.main.async {
                    self.showToast("Error while adding service")
                }
            }
        }
    }
    
    func fetchUserProfile(for userId: String, completion: @escaping (Result<SalonModel, Error>) -> Void) {
        let db = Firestore.firestore()
        let userProfileRef = db.collection("salons").document(userId)
        
        userProfileRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    let userProfile = try document.data(as: SalonModel.self)
                    completion(.success(userProfile))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let documentNotFoundError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User profile document does not exist."])
                completion(.failure(documentNotFoundError))
            }
        }
    }
    
    func updateUserProfile(for userId: String, with updatedData: SalonModel, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let userProfileRef = db.collection("salons").document(userId)
        
        do {
            try userProfileRef.setData(from: updatedData, merge: true) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } catch {
            completion(error)
        }
    }
    
    func fetchAllSalons(completion: @escaping (Result<[SalonModel], Error>) -> Void) {
        let db = Firestore.firestore()
        let salonsCollectionRef = db.collection("salons")
        
        salonsCollectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var salons: [SalonModel] = []
                for document in snapshot!.documents {
                    do {
                        let salon = try document.data(as: SalonModel.self)
                        salons.append(salon)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(salons))
            }
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
