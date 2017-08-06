import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}
