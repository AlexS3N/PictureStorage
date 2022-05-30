
import UIKit

extension UIView {
  
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor,UIColor.gray.cgColor, UIColor.black.cgColor]
        gradient.opacity = 0.7
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func shakeView(view: UIView) {
        UIView.animate(withDuration: 0.1) {
            view.frame.origin.x -= 10
        } completion: { _ in
            UIView.animate(withDuration: 0.05) {
                view.frame.origin.x += 20
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    view.frame.origin.x -= 10
                }
            }
        }
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
    }
}
