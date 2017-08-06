import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var bottomBarViewHeightConstraint: NSLayoutConstraint!

    private var messages: [SampleMessageObject] = []
    private var isUpdating: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0..<20 {
            let isIncoming = arc4random_uniform(2) == 1
            let message = SampleMessageObject(
                message: "Hello World.",
                isIncoming: isIncoming,
                profileImage: #imageLiteral(resourceName: "nishino"),
                createdAt: Date()
            )
            messages.append(message)
        }

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        imageView.image = #imageLiteral(resourceName: "background")
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView

        tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "MessageCell")

        textView.delegate = self

        tableView.transform = __CGAffineTransformMake(1, 0, 0, -1, 0, 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= tableView.contentSize.height - tableView.bounds.size.height &&
            tableView.isDragging {
            if isUpdating {
                return
            }
            DispatchQueue.global().async {
                self.isUpdating = true
                // fetch message logic
                let message = SampleMessageObject(message: "Hei\nYo", isIncoming: true, profileImage: #imageLiteral(resourceName: "nishino"), createdAt: Date())
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isUpdating = false
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            cell.message = "" // resets text because resets cell height estimated from old text.
            cell.isIncoming = messages[indexPath.row].isIncoming
            cell.message = messages[indexPath.row].message
            cell.profileImageView.image = messages[indexPath.row].profileImage
            cell.transform = __CGAffineTransformMake(1, 0, 0, -1, 0, 0)
            return cell
        }

        let cell = UITableViewCell()
        cell.transform = __CGAffineTransformMake(1, 0, 0, -1, 0, 0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.resignFirstResponder()
    }

    @objc private func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        if let duration = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double, let height = rect?.size.height {
            UIView.animate(withDuration: duration) {
                let transform = CGAffineTransform(translationX: 0, y: -height)
                self.view.transform = transform
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification?) {
        if let duration = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.view.transform = CGAffineTransform.identity
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        bottomBarViewHeightConstraint.constant = height
    }

    @IBAction func send(_ sender: UIButton) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        let message = SampleMessageObject(message: self.textView.text, isIncoming: false, profileImage: #imageLiteral(resourceName: "nishino"), createdAt: Date())
        DispatchQueue.global().async {
            self.messages.insert(message, at: 0)
            DispatchQueue.main.async {
                self.textView.text = ""
                self.tableView.reloadData()
                let height = self.textView.sizeThatFits(CGSize(width: self.textView.frame.size.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
                self.bottomBarViewHeightConstraint.constant = height
            }
        }
    }


}

