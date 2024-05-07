

import UIKit

class AlbumVC: UIViewController {

    @IBOutlet weak var AlbumCollection: UICollectionView! {
        didSet {
            AlbumCollection.registerCellFromNib(cellID: "AlbumCollectionViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc func Album(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "CentreVC") as! CentreVC
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }

}


extension AlbumVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        
        
        // This method is similar to
        //cell.RescheduleButton.addTarget(self, action: #selector(RescheduleButton),for: .touchUpInside)
        // But for UIimageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Album))
        cell.Album.isUserInteractionEnabled = true
        cell.Album.addGestureRecognizer(tapGestureRecognizer)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 15) / 2
        let height = ( side * 177 ) / 179
        return CGSize(width:  side, height: height)
    }
}

