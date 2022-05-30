
import UIKit

class ImageViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - var/let
    var imageArray = [Image]()
    var likeButtonIsActive = false
    var currentIndex = 0
    var chosenImage: Int?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapRecognizer()
        self.registerForKeyboardNotifications()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.imageArray = ImageManager.shared.loadResult()
        self.enableDissableButtons()
        if imageArray.isEmpty {
            print("empty")
        } else {
            print("not empty")
            if let index = chosenImage {
                self.imageView.image = ImageManager.shared.loadImage(fileName: imageArray[index].name)
                self.secondImageView.image = imageView.image
                self.currentIndex = index
            }
        }
        self.showDescription()
    }
    //MARK: - IBActions
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        self.previousImage()
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.nextImage()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        if likeButtonIsActive != true {
            self.likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            self.likeButtonIsActive = true
            self.imageArray[currentIndex].like = true
        } else {
            self.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            self.likeButtonIsActive = false
            self.imageArray[currentIndex].like = false
        }
        self.refreshImageArray()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        self.showAlert()
    }
    
    @IBAction func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        }
        if notification.name == UIResponder.keyboardWillShowNotification {
            bottomConstraint.constant = keyboardScreenEndFrame.height + 15
        }
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func tapDetected(_ recognizer: UITapGestureRecognizer) {
        if self.imageArray.isEmpty != true {
            self.imageArray[currentIndex].caption = self.textField.text ?? ""
        }
        self.refreshImageArray()
        view.endEditing(true)
    }
    
    @IBAction func doubleTapDetected(_ secondRecognizer: UITapGestureRecognizer) {
        self.showZoomView()
    }
    
    //MARK: - Flow functions
    private func setupUI() {
        self.superView.addGradient()
        self.subView.addGradient()
        self.scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func previousImage() {
        guard let imageView = imageView,
              let secondImageView = secondImageView else {return}
        if currentIndex <= (imageArray.count - 1) && currentIndex > 0{
            currentIndex -= 1
            secondImageView.image = ImageManager.shared.loadImage(fileName: imageArray[currentIndex].name)
            UIView.animate(withDuration: 0.5) {
                imageView.frame.origin.x = self.view.frame.minX - imageView.frame.width * 2
            } completion: { _ in
                imageView.image = secondImageView.image
                imageView.frame.origin.x = 0
            }
        } else {
            currentIndex = imageArray.count - 1
            secondImageView.image = ImageManager.shared.loadImage(fileName: imageArray[currentIndex].name)
            UIView.animate(withDuration: 0.5) {
                imageView.frame.origin.x = self.view.frame.minX - imageView.frame.width * 2
            } completion: { _ in
                imageView.image = secondImageView.image
                imageView.frame.origin.x = 0
            }
        }
        self.showDescription()
    }
    
    private func nextImage() {
        guard let imageView = imageView,
              let secondImageView = secondImageView else {return}
        if currentIndex < (imageArray.count - 1) {
            currentIndex += 1
            imageView.image = ImageManager.shared.loadImage(fileName: imageArray[currentIndex].name)
            imageView.frame.origin.x  = self.view.frame.maxX + imageView.frame.width
            UIView.animate(withDuration: 0.5) {
                imageView.frame.origin.x = 0
            } completion: { _ in
                secondImageView.image = imageView.image
                self.showDescription()
            }
        } else {
            currentIndex = 0
            imageView.image = ImageManager.shared.loadImage(fileName: imageArray[currentIndex].name)
            imageView.frame.origin.x  = self.view.frame.maxX + imageView.frame.width
            UIView.animate(withDuration: 0.5) {
                imageView.frame.origin.x = 0
            } completion: { _ in
                secondImageView.image = imageView.image
                self.showDescription()
            }
        }
    }
    
    private func refreshImageArray() {
        let results = self.imageArray
        UserDefaults.standard.set(encodable: results, forKey: "description")
    }
    
    private func showDescription() {
        if !imageArray.isEmpty{
            if self.imageArray[self.currentIndex].like {
                self.likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            }
            self.textField.text = self.imageArray[self.currentIndex].caption
        } else {
            self.textField.text = ""
            self.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        }
        self.textField.attributedPlaceholder = NSAttributedString(string: "Add a comment...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
    }
    
    private func showZoomView() {
        let zoomXib = ImageZoom.instanceFromNib()
        zoomXib.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        zoomXib.addGradient()
        zoomXib.zoomScrollView.image = self.imageView.image
        UIView.animate(withDuration: 2) {
            self.view.addSubview(zoomXib)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Attention!", message: "Do you really want to remove the picture from the gallery?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteImage()
        })
        alert.addAction(delete)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteImage() {
        if self.imageArray.count > 1 && self.currentIndex != 0 {
            self.imageArray.remove(at: self.currentIndex)
            self.refreshImageArray()
            self.imageView.image = ImageManager.shared.loadImage(fileName: self.imageArray[self.imageArray.count - 1].name)
            self.secondImageView.image = self.imageView.image
            self.enableDissableButtons()
            self.currentIndex -= 1
            self.showDescription()
        } else if self.imageArray.count > 1 && self.currentIndex == 0 {
            self.imageArray.remove(at: self.currentIndex)
            self.refreshImageArray()
            self.imageView.image = ImageManager.shared.loadImage(fileName: self.imageArray[self.imageArray.count - 1].name)
            self.secondImageView.image = self.imageView.image
            self.enableDissableButtons()
            self.currentIndex = self.imageArray.count - 1
            self.showDescription()
        } else if self.imageArray.count == 1 {
            self.imageArray.remove(at: self.currentIndex)
            self.refreshImageArray()
            self.imageView.image = .none
            self.secondImageView.image = .none
            self.enableDissableButtons()
            self.showDescription()
        }
    }
    
    private func enableDissableButtons() {
        if self.imageArray.count == 0 {
            self.conditionButtons(bool: false)
        } else if self.imageArray.count == 1 {
            self.conditionButtons(bool: true)
            self.previousButton.isEnabled = false
            self.nextButton.isEnabled = false
        } else {
            self.conditionButtons(bool: true)
        }
    }
    
    private func conditionButtons(bool: Bool) {
        self.previousButton.isEnabled = bool
        self.nextButton.isEnabled = bool
        self.deleteButton.isEnabled = bool
        self.likeButton.isEnabled = bool
        self.textField.isEnabled = bool
    }

    private func addTapRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected(_:)))
        self.view.addGestureRecognizer(recognizer)
        let secondRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected(_:)))
        secondRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(secondRecognizer)
    }
}
