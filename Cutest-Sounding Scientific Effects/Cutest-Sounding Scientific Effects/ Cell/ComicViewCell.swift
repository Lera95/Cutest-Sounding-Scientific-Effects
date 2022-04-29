import UIKit

struct ComicCellViewModel {
    let image: UIImage
    let jokeTitle: String
    let jokeText: String

}

class ComicViewCell: UITableViewCell {
    @IBOutlet private weak var jokeImage: UIImageView!
    @IBOutlet private weak var jokeTextLabel: UILabel!
    @IBOutlet private weak var descriptionTextLabel: UILabel!

    static let identifier = "ComicViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(with viewModel: ComicCellViewModel) {
        jokeImage.image = viewModel.image
        jokeTextLabel.text = viewModel.jokeText
        descriptionTextLabel.text = viewModel.jokeTitle
    }
}
