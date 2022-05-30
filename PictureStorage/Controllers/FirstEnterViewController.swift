
import UIKit

class FirstEnterViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var createPasswordView: UIView!
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var isPasswordCreated = false

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let password = UserDefaults.standard.object(forKey: "password") as? String {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as? PasswordViewController else {
                return
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createPasswordView.layer.cornerRadius = 15
        self.subView.addGradient()
    }
    
    //MARK: - IBActions
    @IBAction func savePasswordButtonPressed(_ sender: UIButton) {
        if self.createPasswordTextField.text == self.repeatPasswordTextField.text && self.createPasswordTextField.text != "" {
            let password = self.createPasswordTextField.text
            UserDefaults.standard.set(password, forKey: "password")
            self.showAlert()
        } else {
            self.createPasswordTextField.shakeView(view: createPasswordTextField)
            self.repeatPasswordTextField.shakeView(view: repeatPasswordTextField)
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
