import UIKit

class BookingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var appointmentDateAndTimeLabel: UILabel!
    @IBOutlet weak var customerImage: UIImageView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerServiceNameLabel: UILabel!
    @IBOutlet weak var customerServiceId: UILabel!
    @IBOutlet weak var customerServiceDuration: UILabel!
    @IBOutlet weak var RescheduleButton: UIButton!
    @IBOutlet weak var cancelServiceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
