//
//  dataModel.swift
//  QuickCutsAdminApp
//
//  Created by Akshat Gulati on 08/05/24.
//

import Foundation
import UIKit


struct upcomingBookingDM {
    let dateAndTime: String
    let custImage: String
    let custName: String
    let custServiceName: String
    let custServiceId: String
    let custServiceDuration: String
}
struct CompletedServicesDM {
    let dateAndTime: String
    let custImage: String
    let custName: String
    let custServiceName: String
    let custServiceId: String
    let custServiceDuration: String
}

struct CancelledServicesDM {
    let dateAndTime: String
    let custImage: String
    let custName: String
    let custServiceName: String
    let custServiceId: String
    let custServiceDuration: String
}
