import UIKit

class SymptomTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
