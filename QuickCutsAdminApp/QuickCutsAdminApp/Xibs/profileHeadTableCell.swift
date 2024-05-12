import UIKit

class profileHeadTableCell: UITableViewCell {

    @IBOutlet weak var salonImage: UIImageView!
    @IBOutlet weak var salonName: UILabel!
    @IBOutlet weak var salonPhoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
