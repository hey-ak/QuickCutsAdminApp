//
//  BookingCollectionCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 21/04/24.
//

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
        // Initialization code
    }
}
