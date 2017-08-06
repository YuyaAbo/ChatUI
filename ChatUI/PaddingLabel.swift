import UIKit

@IBDesignable
class PaddingLabel: UILabel {

    var padding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, padding)
        super.drawText(in: newRect)
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }

}
