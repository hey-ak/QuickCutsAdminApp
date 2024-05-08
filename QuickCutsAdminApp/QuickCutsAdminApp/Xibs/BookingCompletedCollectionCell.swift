//
//  BookingCompletedCollectionCell.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 21/04/24.
//

import UIKit

class BookingCompletedCollectionCell: UICollectionViewCell {
    @IBOutlet weak var completedServiceDateAndTimeLabel: UILabel!
    
    @IBOutlet weak var completedUserImage: UIImageView!
    
    @IBOutlet weak var completedUserName: UILabel!
    
    @IBOutlet weak var completedUserServicesLabel: UILabel!
    
    @IBOutlet weak var completedServiceID: UILabel!
    
    @IBOutlet weak var completedServiceDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
