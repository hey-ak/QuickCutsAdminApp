import UIKit

class BookingVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bookingCollectionView: UICollectionView!{
        didSet{
            bookingCollectionView.registerCellFromNib(cellID: "BookingCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCancelledCollectionCell")
            bookingCollectionView.registerCellFromNib(cellID: "BookingCompletedCollectionCell")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @objc func RescheduleButton(){
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func segmentControlDidChange(_ sender: UISegmentedControl) {
        bookingCollectionView.reloadData()
    }

}


extension BookingVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentSegment = segmentControl.selectedSegmentIndex
        switch currentSegment {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCollectionCell", for: indexPath) as? BookingCollectionCell {
                
                cell.RescheduleButton.addTarget(self, action: #selector(RescheduleButton),for: .touchUpInside)
                
                return cell
            }

        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCompletedCollectionCell", for: indexPath) as? BookingCompletedCollectionCell {
                return cell
            }

        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingCancelledCollectionCell", for: indexPath) as? BookingCancelledCollectionCell {
                return cell
            }

        default: break
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width * 243) / 362
        return CGSize(width: collectionView.frame.size.width, height: side)
    }
}
