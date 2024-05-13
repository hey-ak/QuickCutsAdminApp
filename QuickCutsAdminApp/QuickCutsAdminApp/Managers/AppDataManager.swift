import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class AppDataManager {
    
    static let shared = AppDataManager()
    private var db = Firestore.firestore()
    private let userDefaults = UserDefaults.standard
    
    public func isInitialLaunchSetup() {
        guard userDefaults.value(forKey: "IsInitialLaunch") as? Bool == false else { return }
        userDefaults.set(true, forKey: "IsInitialLaunch")
        fetchAndSaveProfile()
    }
    
    public func fetchAndSaveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        AppDataManager.shared.fetchUserProfile(for: userId) { result in
            switch result {
            case .success(let userProfile):
                DispatchQueue.main.async {
                    AppDataManager.shared.saveUserProfile(userProfile)
                    AppDataManager.shared.saveLoggedUserID(userId)
                }
                
            default:break
                
            }
        }
    }
    
    public func saveLoggedUserID(_ userId:String) {
        userDefaults.set(userId, forKey: UserDefaultKeys.userID.rawValue)
    }
    
    public func getLoggedUserId() -> String? {
        return userDefaults.value(forKey: UserDefaultKeys.userID.rawValue) as? String
    }
    
    public func saveUserProfile(_ profile: SalonModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
    }
    
    public func loadUserProfile() -> SalonModel? {
        if let savedProfile = UserDefaults.standard.object(forKey: "userProfile") as? Data {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(SalonModel.self, from: savedProfile) {
                return loadedProfile
            }
        }
        return nil
    }
    
    public func logoutUser() -> Result<Void, LogoutError> {
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: UserDefaultKeys.userID.rawValue)
            return .success(())
        } catch let signOutError as NSError {
            let errorDescription = "Error signing out: \(signOutError.localizedDescription)"
            return .failure(.signOutFailed(reason: errorDescription))
        }
    }
    
    public func createUserProfile(_ userId: String, _ userData: SalonModel) {
        do {
            let userProfileRef = db.collection("salons").document(userId)
            try userProfileRef.setData(from: userData)
        } catch {
            showToast(error.localizedDescription)
        }
    }
    
    public func fetchUserProfile(for userId: String, completion: @escaping (Result<SalonModel, Error>) -> Void) {
        let userProfileRef = db.collection("salons").document(userId)
        userProfileRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    if let document = document, document.exists {
                        let userProfile = try document.data(as: SalonModel.self)
                        completion(.success(userProfile))
                    } else {
                        completion(.failure(UserProfileError.documentNotFound))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func updateUserProfile(for userId: String, with updatedData: SalonModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let userProfileData = try Firestore.Encoder().encode(updatedData)
            let userProfileRef = db.collection("salons").document(userId)
            
            userProfileRef.setData(userProfileData, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    public func uploadProfileImage(_ image: UIImage, for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.failure(ProfileImageError.imageDataConversionFailed))
            return
        }
        
        let storageRef = Storage.storage().reference().child("AdminProfile/\(userId).jpg")
        let md = StorageMetadata()
        md.contentType = "image/png"
        storageRef.putData(imageData, metadata: md) { metadata, error in
            guard let _ = metadata else {
                completion(.failure(error ?? ProfileImageError.unknownError))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let downloadURL = url {
                    
                    AppDataManager.shared.fetchUserProfile(for: userId) { result in
                        switch result {
                        case .success(let userProfile):
                      
                                var userProfile = userProfile
                            userProfile.image = downloadURL.absoluteString
                                
                                self.updateUserProfile(for: userId, with: userProfile) { result in
                                    switch result {
                                    case .success:
                                        DispatchQueue.main.async {
                                            AppDataManager.shared.saveUserProfile(userProfile)
                                            AppDataManager.shared.saveLoggedUserID(userId)
                                            completion(.success(downloadURL.absoluteString))
                                        }
                                    case .failure(let error):
                                        DispatchQueue.main.async {
                                            completion(.failure(error))
                                        }
                                    }
                                }
                        default:
                            completion(.failure(error ?? ProfileImageError.unknownError))
                        }
                    }
                } else {
                    completion(.failure(error ?? ProfileImageError.unknownError))
                }
            }
        }
    }
    
    public func userProfileImageURL(for userId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let storage = Storage.storage()
        let profileImageRef = storage.reference().child("profile_images/\(userId).jpg")
        
        profileImageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let downloadURL = url {
                    completion(.success(downloadURL))
                } else {
                    completion(.failure(UserProfileError.downloadURLNotFound))
                }
            }
        }
    }
    
    public func getSalonReview(_ salonId:String) {
        ReviewManager.shared.getReviews(forUserId: salonId) { [weak self] reviews, error in
            if let error = error { print( error.localizedDescription ) }
            else if let reviews = reviews {
                if reviews.count > 0 {
                    self?.processRating(reviews)
                }
            }
        }
    }
    
    private func processRating(_ reviews: [SalonReview]) {
        var totleStarsCount = 0
        var allUserTotleStars:Int = 0
        var commentsTotle = 0
        
        for review in reviews {
            guard let comments = review.userCommentData else { continue }
            commentsTotle = commentsTotle + comments.count
            totleStarsCount = totleStarsCount + (comments.count * 5 * 5)
            
            for review1 in comments {
                if let serviceRating = review1.serviceRating,
                   let hygieneRating = review1.hygieneRating,
                   let staffRating = review1.staffRating,
                   let moneyRating = review1.moneyRating,
                   let experienceRating = review1.experienceRating {
                    
                    let totleStars = serviceRating + hygieneRating + staffRating + moneyRating + experienceRating
                    allUserTotleStars = allUserTotleStars + totleStars
                }
            }
        }
        
        let averageStar = Int(allUserTotleStars / (totleStarsCount / 5))
        updateReviewData(averageStar, commentCount: commentsTotle)
    }
    
    private func updateReviewData(_ averageRating:Int,commentCount:Int) {
        guard let saloneId = Auth.auth().currentUser?.uid else { return }
        
        FirebaseManager().getSalon(salonId: saloneId) {[weak self] (salon, error) in
            guard error == nil,var salone = salon else { return }
            
            var userProfile = salone
            userProfile.reviews = commentCount
            userProfile.rating = Double(averageRating)
            
            self?.updateUserProfile(for: saloneId, with: userProfile) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async { }
                case .failure(let error):
                    DispatchQueue.main.async { }
                }
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

struct UserProfile:Codable {
    
    var userId:String
    var name:String?
    var profile:String?
    var userType:String?
    var phoneNumber:String?
    
    mutating func convertDocumentToStruct(doc: DocumentSnapshot) {
        self.userId = doc.get("userId") as? String ?? "nil"
        self.name = doc.get("name") as? String
        self.profile = doc.get("profile") as? String
        self.userType = doc.get("userType") as? String
        self.phoneNumber = doc.get("phoneNumber") as? String
    }
}
