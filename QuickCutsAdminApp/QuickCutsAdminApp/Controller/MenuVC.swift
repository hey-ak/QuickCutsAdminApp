import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class MenuVC: UIViewController {
    
    private var salonData = [SalonServices]()
    
    @IBOutlet weak var menuCollectionView: UICollectionView!{
        didSet{
            menuCollectionView.registerCellFromNib(cellID: "MenuCollectionViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllSalons()
    }
    
    @IBAction func addToMenuTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "AddServicesVC") as! AddServicesVC
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func getAllSalons() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        fetchSalonServices(for: uid) { result in
            switch result {
            case .success(let salons):
                let salon = salons
                DispatchQueue.main.async {
                    self.salonData = salon
                    self.menuCollectionView.reloadData()
                }
            default:break
            }
        }
    }
    
    private func fetchAllSalons(completion: @escaping (Result<[SalonModel], Error>) -> Void) {
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
                        continue
                    }
                }
                completion(.success(salons))
            }
        }
    }
    
    private func fetchSalonServices(for userId: String, completion: @escaping (Result<[SalonServices], Error>) -> Void) {
        let db = Firestore.firestore()
        let salonRef = db.collection("salons").document(userId)
        
        salonRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    let salonData = try document.data(as: SalonModel.self)
                    if let services = salonData.services {
                        completion(.success(services))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No services available"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Salon document not found"])))
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
extension MenuVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        salonData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        let data = salonData[indexPath.row]
        
        cell.menuServiceCost.setTitle("\(data.servicePrice ?? 0.0)", for: .normal)
        cell.menuServiceName.setTitle(data.serviceName, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let b = ( collectionView.layer.frame.width - 30 ) / 3
        let l = ( collectionView.layer.frame.width - 30 ) / 3
        return CGSize(width: b, height: l)
    }
}

