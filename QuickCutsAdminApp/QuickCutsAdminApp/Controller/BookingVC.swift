import UIKit

class BookingVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bookingCollectionView: UICollectionView!{
        didSet{
            bookingCollectionView.registerCellFromNib(cellID: "BookingCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCancelledCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCompletedCollectionCell")
        }
    }
    
    let dummyUpcomingBookings = [
        upcomingBookingDM(dateAndTime: "2024-05-10 15:00", custImage: "custImage1", custName: "John Doe", custServiceName: "Haircut", custServiceId: "SVC1001", custServiceDuration: "30 mins"),
        upcomingBookingDM(dateAndTime: "2024-05-11 12:00", custImage: "custImage2", custName: "Jane Smith", custServiceName: "Facial", custServiceId: "SVC1002", custServiceDuration: "45 mins"),
        upcomingBookingDM(dateAndTime: "2024-05-12 10:00", custImage: "custImage3", custName: "Chris Johnson", custServiceName: "Shave", custServiceId: "SVC1003", custServiceDuration: "15 mins"),
        upcomingBookingDM(dateAndTime: "2024-05-13 14:00", custImage: "custImage4", custName: "Patricia Lee", custServiceName: "Hair Color", custServiceId: "SVC1004", custServiceDuration: "1 hour"),
        upcomingBookingDM(dateAndTime: "2024-05-14 16:00", custImage: "custImage5", custName: "Michael Brown", custServiceName: "Nail Art", custServiceId: "SVC1005", custServiceDuration: "1 hour 30 mins"),
        upcomingBookingDM(dateAndTime: "2024-05-15 11:00", custImage: "custImage6", custName: "Laura Wilson", custServiceName: "Spa", custServiceId: "SVC1006", custServiceDuration: "2 hours")
    ]

    let dummyCompletedServices = [
        CompletedServicesDM(dateAndTime: "2024-04-30 14:00", custImage: "custImage7.png", custName: "Alex Johnson", custServiceName: "Massage", custServiceId: "SVC1007", custServiceDuration: "1 hour"),
        CompletedServicesDM(dateAndTime: "2024-05-01 16:00", custImage: "custImage8.png", custName: "Emily Davis", custServiceName: "Manicure", custServiceId: "SVC1008", custServiceDuration: "30 mins"),
        CompletedServicesDM(dateAndTime: "2024-05-02 09:00", custImage: "custImage9.png", custName: "David Smith", custServiceName: "Beard Trim", custServiceId: "SVC1009", custServiceDuration: "20 mins"),
        CompletedServicesDM(dateAndTime: "2024-05-03 13:00", custImage: "custImage10.png", custName: "Sophia Martinez", custServiceName: "Eyebrow Shaping", custServiceId: "SVC1010", custServiceDuration: "15 mins"),
        CompletedServicesDM(dateAndTime: "2024-05-04 15:00", custImage: "custImage11.png", custName: "James Wilson", custServiceName: "Hair Treatment", custServiceId: "SVC1011", custServiceDuration: "1 hour 15 mins"),
        CompletedServicesDM(dateAndTime: "2024-05-05 17:00", custImage: "custImage12.png", custName: "Linda Garcia", custServiceName: "Acrylic Nails", custServiceId: "SVC1012", custServiceDuration: "1 hour 45 mins")
    ]

    let dummyCancelledServices = [
        CancelledServicesDM(dateAndTime: "2024-05-08 13:00", custImage: "custImage13.png", custName: "Michael Brown", custServiceName: "Pedicure", custServiceId: "SVC1013", custServiceDuration: "30 mins"),
        CancelledServicesDM(dateAndTime: "2024-05-09 11:00", custImage: "custImage14.png", custName: "Sarah Wilson", custServiceName: "Hair Dye", custServiceId: "SVC1014", custServiceDuration: "2 hours"),
        CancelledServicesDM(dateAndTime: "2024-05-06 10:00", custImage: "custImage15.png", custName: "Daniel Lee", custServiceName: "Waxing", custServiceId: "SVC1015", custServiceDuration: "45 mins"),
        CancelledServicesDM(dateAndTime: "2024-05-07 12:00", custImage: "custImage16.png", custName: "Jessica Garcia", custServiceName: "Threading", custServiceId: "SVC1016", custServiceDuration: "30 mins"),
        CancelledServicesDM(dateAndTime: "2024-05-08 14:00", custImage: "custImage17.png", custName: "William Martinez", custServiceName: "Deep Tissue Massage", custServiceId: "SVC1017", custServiceDuration: "1 hour"),
        CancelledServicesDM(dateAndTime: "2024-05-09 16:00", custImage: "custImage18.png", custName: "Emma Hernandez", custServiceName: "Body Scrub", custServiceId: "SVC1018", custServiceDuration: "1 hour 30 mins")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @objc func RescheduleButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
        bookingCollectionView.reloadData()
    }
    @objc func cancelServiceButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CancelScreenViewController") as! CancelScreenViewController
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    

}


extension BookingVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyUpcomingBookings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSegment = segmentControl.selectedSegmentIndex
        switch currentSegment {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionCell", for: indexPath) as? BookingCollectionCell {
                
                let data = dummyUpcomingBookings[indexPath.row]
                cell.appointmentDateAndTimeLabel.text = data.dateAndTime
                cell.customerImage.image = UIImage(named: data.custImage)
                cell.customerNameLabel.text = data.custName
                cell.customerServiceNameLabel.text = "Service Name: \(data.custServiceName)"
                cell.customerServiceId.text = "Service ID: \(data.custServiceId)"
                cell.customerServiceDuration.text = "Service Duration: \(data.custServiceDuration)"
    
                cell.RescheduleButton.addTarget(self, action: #selector(RescheduleButton),for: .touchUpInside)
                cell.cancelServiceButton.addTarget(self, action: #selector(cancelServiceButton),for: .touchUpInside)
                return cell
            }

        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCompletedCollectionCell", for: indexPath) as? BookingCompletedCollectionCell {
                
                let data = dummyCompletedServices[indexPath.row]
                cell.completedServiceDateAndTimeLabel.text = data.dateAndTime
                cell.completedUserImage.image = UIImage(named: data.custImage)
                cell.completedUserName.text = data.custName
                cell.completedUserServicesLabel.text = "Service Name: \(data.custServiceName)"
                cell.completedServiceID.text = "Service ID: \(data.custServiceId)"
                cell.completedServiceDurationLabel.text = "Service Duration: \(data.custServiceDuration)"
                
                return cell
            }

        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCancelledCollectionCell", for: indexPath) as? BookingCancelledCollectionCell {
                
                
                let data = dummyCompletedServices[indexPath.row]
                cell.cancelledDateAndTimeLabel.text = data.dateAndTime
//                cell.cancelledUserImage.image = UIImage(named: data.custImage)
                cell.cancelledCustomerName.text = data.custName
                cell.cancelledServiceNameLabel.text = "Service Name: \(data.custServiceName)"
                cell.cancelledServiceIDLabel.text = "Service ID: \(data.custServiceId)"
                cell.cancelledServiceDurationLabel.text = "Service Duration: \(data.custServiceDuration)"
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
