//
//  CentreSettingsViewController.swift
//  QuickCutsAdminApp
//
//  Created by Akshat Gulati on 01/05/24.
//

import UIKit

class CentreSettingsViewController: UIViewController {
    
    let centreSettingsData = [
        [" "],
        ["Centre Setting", "Payment Method", "Transactions"],
        ["Settings", "Help Centre", "Privacy Policy", "Log-out"],
        ]

    
    
    @IBOutlet weak var CentreTableView: UITableView!{
        didSet{
            CentreTableView.registerCellFromNib(cellID: "ProfileTableCell")
            CentreTableView.registerCellFromNib(cellID: "dummyTableCell")
            CentreTableView.registerCellFromNib(cellID: "SalonSettingHeadTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CentreTableView.sectionHeaderTopPadding = 0
    }
}


extension CentreSettingsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        centreSettingsData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalonSettingHeadTableViewCell", for: indexPath) as! SalonSettingHeadTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            cell.profileLabel?.text = centreSettingsData[indexPath.section][indexPath.row]
            
            if indexPath.row == 0 {
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else if indexPath.row == centreSettingsData[section].count - 1 {
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else {
                cell.contentView.layer.maskedCorners = []
                cell.contentView.layer.cornerRadius = 0
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            cell.profileLabel?.text = centreSettingsData[indexPath.section][indexPath.row]
            
            if indexPath.row == 0 {
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else if indexPath.row == centreSettingsData[section].count - 1 {
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.contentView.layer.cornerRadius = 13
            }
            else {
                cell.contentView.layer.maskedCorners = []
                cell.contentView.layer.cornerRadius = 0
            }
            
            return cell
        default : return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // guard section > 0 else { return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dummyTableCell") as! dummyTableCell
        return cell.contentView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
}
