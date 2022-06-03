import UIKit
import Kingfisher

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

    private let titleText = L10n.DetailsComicViewController.title

    static let identifier = L10n.DetailsComicViewController.identifier

    var presenter: DetailsComicViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        title = titleText
        textLabel.numberOfLines = 0
        setUpButtonImage()
    }
    // MARK: - Private
    
    private func setUpButtonImage() {
        randomButton.setImage(Asset.shuffle.image, for: .normal)
        previousButton.setImage(Asset.backward.image, for: .normal)
        nextButton.setImage(Asset.forward.image, for: .normal)
        lastButton.setImage(Asset.forwardEnd.image, for: .normal)
        firstButton.setImage(Asset.backwardEnd.image, for: .normal)
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
        DispatchQueue.main.async { [weak self] in
            let url = URL(string: comic.img)
            self?.imageView.kf.indicatorType = .activity
            self?.imageView.kf.setImage(with: url)
            self?.textLabel.text = comic.alt
        }
    }
}
