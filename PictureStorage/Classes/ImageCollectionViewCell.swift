
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var array = ImageManager.shared.loadResult()
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with image: Image) {
        imageView.image = ImageManager.shared.loadImage(fileName: image.name)        
    }
}
