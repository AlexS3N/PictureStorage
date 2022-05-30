
import UIKit

class CustomAlert: UIView {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    static func instanceFromNib() -> CustomAlert {
        guard let view = UINib(nibName: "CustomAlert", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CustomAlert else {
            return CustomAlert()
        }
        return view
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        removeFromSuperview()
    }
}
