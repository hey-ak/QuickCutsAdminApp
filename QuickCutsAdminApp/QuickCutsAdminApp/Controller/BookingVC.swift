import UIKit
import SDWebImage
import FirebaseAuth

class BookingVC: UIViewController {
    
    private var bookings = [BookingModel]()
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bookingCollectionView: UICollectionView!{
        didSet{
            bookingCollectionView.registerCellFromNib(cellID: "BookingCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCancelledCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCompletedCollectionCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshReviewData()
    }
    
    private func refreshReviewData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        AppDataManager.shared.getSalonReview(userId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        BookingManager.shared.getBookings(forUserId:userId) { bookings, error in
            if let error = error {
                print("Error retrieving bookings: \(error.localizedDescription)")
            } else {
                if let bookings = bookings {
                    DispatchQueue.main.async {
                        self.bookings = bookings
                        self.bookingCollectionView.reloadData()
                    }
                } else {
                    print("No bookings found for the user.")
                }
            }
        }
    }
    
    @objc
    func RescheduleButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
        bookingCollectionView.reloadData()
    }
    
    @objc
    func cancelServiceButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CancelScreenViewController") as! CancelScreenViewController
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func getServiceNames(_ services: [SalonServices]?) -> String? {
        guard let services = services else { return nil }
        var servicesArray = [String]()
        for service in services {
            if let name = service.serviceName {
                servicesArray.append(name)
            }
        }
        let serviceName = servicesArray.joined(separator: ",")
        return serviceName
    }
}
extension BookingVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSegment = segmentControl.selectedSegmentIndex
        switch currentSegment {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionCell", for: indexPath) as? BookingCollectionCell {
                let data = bookings[indexPath.row]
                cell.appointmentDateAndTimeLabel.text = data.bookingDate
                
                if let url = data.userProfileImage,
                   let profileUrl = URL(string: url) {
                    cell.customerImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.customerImage.sd_setImage(with: profileUrl,
                                                      placeholderImage: UIImage(named: "profilePic"))
                }
                else {
                    cell.customerImage.image = UIImage(named: "profilePic")
                }

                cell.customerNameLabel.text = data.userName
                let serviceName = getServiceNames(data.services)
                cell.customerServiceNameLabel.text = "Services : \(serviceName ?? "")"
                cell.customerServiceId.text = "Service ID: \(data.id)"
                cell.customerServiceDuration.text = "Service Duration: \((data.services?.count ?? 0) * 30) min"
                cell.RescheduleButton.addTarget(self, action: #selector(RescheduleButton),for: .touchUpInside)
                cell.cancelServiceButton.addTarget(self, action: #selector(cancelServiceButton),for: .touchUpInside)
                return cell
            }

        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCompletedCollectionCell", for: indexPath) as? BookingCompletedCollectionCell {
                
//                let data = dummyCompletedServices[indexPath.row]
//                cell.completedServiceDateAndTimeLabel.text = data.dateAndTime
//                cell.completedUserImage.image = UIImage(named: data.custImage)
//                cell.completedUserName.text = data.custName
//                cell.completedUserServicesLabel.text = "Service Name: \(data.custServiceName)"
//                cell.completedServiceID.text = "Service ID: \(data.custServiceId)"
//                cell.completedServiceDurationLabel.text = "Service Duration: \(data.custServiceDuration)"
                
                return cell
            }

        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCancelledCollectionCell", for: indexPath) as? BookingCancelledCollectionCell {
//                let data = dummyCompletedServices[indexPath.row]
//                cell.cancelledDateAndTimeLabel.text = data.dateAndTime
//                cell.cancelledUserImage.image = UIImage(named: data.custImage)
//                cell.cancelledCustomerName.text = data.custName
//                cell.cancelledServiceNameLabel.text = "Service Name: \(data.custServiceName)"
//                cell.cancelledServiceIDLabel.text = "Service ID: \(data.custServiceId)"
//                cell.cancelledServiceDurationLabel.text = "Service Duration: \(data.custServiceDuration)"
                return cell
            }

        default: break
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width * 243) / 362
        return CGSize(width: collectionView.frame.size.width, height: side)
    }
}

struct BookingModel:Codable {
    let id:Int
    let saloneImgae:String?
    let salonId:String
    let userId:String
    let saloneName:String?
    let userName:String?
    let address:String?
    let services:[SalonServices]?
    let selectedTimeIds:[Int]?
    let bookingDate:String?
    let isCancled:Bool?
    let expiryDate:Date?
    let userProfileImage:String?
    let isCancelledBySalone:String?
}
