//
//  AppointmentsViewController.swift
//  QuickCutsAdminApp
//
//  Created by Akshat Gulati on 01/05/24.
//

import UIKit

class AppointmentsViewController: UIViewController {

    
    @IBOutlet weak var appointmentsToday: UICollectionView!{
        didSet{
            appointmentsToday.registerCellFromNib(cellID: "BookingCollectionCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc func RescheduleButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func cancelServiceButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CancelScreenViewController") as! CancelScreenViewController
            nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    

}
extension AppointmentsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionCell", for: indexPath) as! BookingCollectionCell
        
        cell.RescheduleButton.addTarget(self, action: #selector(RescheduleButton),for: .touchUpInside)
        cell.cancelServiceButton.addTarget(self, action: #selector(cancelServiceButton),for: .touchUpInside)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width * 243) / 362
       return CGSize(width: collectionView.frame.size.width, height: side)
    }
    
}
