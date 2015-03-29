import UIKit

class SweetTableViewCell: UITableViewCell {

    @IBOutlet  var usernameLabel: UILabel! = UILabel()
    @IBOutlet  var timestampLabel: UILabel! = UILabel()
    @IBOutlet  var sweetTextView: UITextView! = UITextView()
    @IBOutlet weak var profImg: UIImageView! = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
