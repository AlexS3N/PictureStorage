
import UIKit

class MainViewController: UIViewController {
   
    //MARK: - IBOutlets
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - vars/lets
    var array: [Image]?
    let distance: CGFloat = 10
    let amountRowElements = 3
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addGradient()
        self.array = ImageManager.shared.loadResult()
        collectionView.reloadData()
    }
}
    
    //MARK: - Extensions
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageManager.shared.loadResult().count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == 0 {
            cell.imageView.image = UIImage(named: "addImage")
        }
        if indexPath.item > 0 {
            if let array = self.array {
                cell.configure(with: array[indexPath.item - 1])
            }
        }
        cell.layer.cornerRadius = 15
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - distance * CGFloat(amountRowElements + 1))/CGFloat(amountRowElements)
        return CGSize(width: side, height: side)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: distance, left: distance, bottom: distance, right: distance)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return distance
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
            collectionView.reloadData()
        }
        if indexPath.item > 0 {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {
                return
            }
            controller.chosenImage = indexPath.item - 1
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
