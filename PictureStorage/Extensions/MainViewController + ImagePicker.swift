
import UIKit

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageName = ImageManager.shared.saveImage(image) {
                let imageObject = Image(name: imageName, caption: "", like: false)
                ImageManager.shared.saveResult(imageObject)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

