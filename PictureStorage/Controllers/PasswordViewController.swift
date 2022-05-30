
import UIKit

class PasswordViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    
    //MARK: - LIfecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.passwordView.layer.cornerRadius = 15
        self.subView.addGradient()
    }
    
    //MARK: - IBActions
    @IBAction func okButtonPressed(_ sender: UIButton) {
        guard let password = UserDefaults.standard.object(forKey: "password") as? String else {
            return
        }
        if self.enterPasswordTextField.text == password {
            self.showAlert()
        } else {
            self.enterPasswordTextField.shakeView(view: enterPasswordTextField)
        }
    }
    
    @IBAction func enterApp(_ sender: UIButton) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Flow functions
    func showAlert() {
        let customAlert = CustomAlert.instanceFromNib()
        customAlert.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        customAlert.alertView.layer.cornerRadius = 15
        customAlert.cancelButton.addTarget(self, action: #selector(enterApp(_:)), for: .touchUpInside)
        self.view.addSubview(customAlert)
    }
}

