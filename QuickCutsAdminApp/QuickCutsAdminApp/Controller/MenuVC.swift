//
//  MenuVC.swift
//  QuickCutsAdminApp
//
//  Created by Akshat Gulati on 07/05/24.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var menuCollectionView: UICollectionView!{
        didSet{
            menuCollectionView.registerCellFromNib(cellID: "MenuCollectionViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
extension MenuVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let b = ( collectionView.layer.frame.width - 30 ) / 3
        let l = ( collectionView.layer.frame.width - 30 ) / 3
        return CGSize(width: b, height: l)
    }
}

