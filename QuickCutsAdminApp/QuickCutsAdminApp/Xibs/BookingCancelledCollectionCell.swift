//
//  BookingCancelledCollectionCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 21/04/24.
//

import UIKit

class BookingCancelledCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cancelledCustomerName: UILabel!
    @IBOutlet weak var cancelledServiceDurationLabel: UILabel!
    @IBOutlet weak var cancelledServiceIDLabel: UILabel!
    @IBOutlet weak var cancelledServiceNameLabel: UILabel!
    @IBOutlet weak var cancelledUserImage: UIImageView!
    @IBOutlet weak var cancelledDateAndTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
