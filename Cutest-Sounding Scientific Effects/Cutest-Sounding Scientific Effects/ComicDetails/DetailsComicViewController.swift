import UIKit

protocol DetailsComicViewControllerProtocol: AnyObject{
    func downloaded(comic: XkcdManagerModel)
}

class DetailsComicViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var randomButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var lastButton: UIButton!
    @IBOutlet private weak var firstButton: UIButton!

    private let titleText = "Find the best or randomize"

    static let identifier = "DetailsComicViewController"

    lazy var presenter = DetailsComicViewPresenter(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        title = titleText
        textLabel.numberOfLines = 0
        setUpButtonImage()
    }

    func setComicId(with id: Int) {
        presenter.setComicId(with: id)
    }

    // MARK: - Private

    private func setUpButtonImage() {
        randomButton.setImage(UIImage.shuffle, for: .normal)
        previousButton.setImage(UIImage.backward, for: .normal)
        nextButton.setImage(UIImage.forward, for: .normal)
        lastButton.setImage(UIImage.forwardEnd, for: .normal)
        firstButton.setImage(UIImage.backwardEnd, for: .normal)
    }

    // MARK: - @IBAction

    @IBAction private func prevTapped(_ sender: Any) {
        presenter.prevTapped()
    }

    @IBAction private func lastTapped(_ sender: Any) {
        presenter.lastTapped()
    }

    @IBAction private func randomTapped(_ sender: Any) {
        presenter.randomTapped()
    }

    @IBAction private func forwardTapped(_ sender: Any) {
        presenter.forwardTapped()
    }

    @IBAction private func firstTapped(_ sender: Any) {
        presenter.forwardTapped()
    }
}

// MARK: - DetailsComicViewControllerProtocol

extension DetailsComicViewController: DetailsComicViewControllerProtocol {

    func downloaded(comic: XkcdManagerModel) {
        DispatchQueue.main.async {
            self.imageView.downloaded(from: comic.img)
            self.textLabel.text = comic.alt
        }
    }
}
