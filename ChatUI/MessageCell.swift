import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var incomingMessageLabel: UILabel!
    @IBOutlet weak var outgoingMessageLabel: UILabel!
    @IBOutlet weak var incomingCreatedAtLabel: UILabel!
    @IBOutlet weak var outgoingCreatedAtLabel: UILabel!

    var isIncoming: Bool = false {
        didSet {
            if isIncoming {
                profileImageView.isHidden = false
                incomingMessageLabel.isHidden = false
                incomingCreatedAtLabel.isHidden = false
                outgoingMessageLabel.isHidden = true
                outgoingCreatedAtLabel.isHidden = true
            } else {
                profileImageView.isHidden = true
                incomingMessageLabel.isHidden = true
                incomingCreatedAtLabel.isHidden = true
                outgoingMessageLabel.isHidden = false
                outgoingCreatedAtLabel.isHidden = false
            }
        }
    }

    var message: String = "" {
        didSet {
            if isIncoming {
                incomingMessageLabel.text = message
            } else {
                outgoingMessageLabel.text = message
            }
        }
    }

}
