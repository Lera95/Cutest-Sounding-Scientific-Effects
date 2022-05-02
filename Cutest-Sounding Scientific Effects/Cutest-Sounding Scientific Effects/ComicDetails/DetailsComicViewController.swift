import UIKit

protocol DetailsComicViewControllerProtocol: AnyObject{
    func downloaded(comic: XkcdManegerModel)
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
    
    private lazy var presenter = DetailsComicViewPresenter(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonImage()
        title = titleText
        textLabel.numberOfLines = 0
    }

    func setComicId(with id: Int) {
        presenter.currentComic = id
        presenter.getCurrrentComic()
    }

    // MARK: - Private

    private func setUpButtonImage() {
        randomButton.setImage(UIImage(named: "shuffle"), for: .normal)
        previousButton.setImage(UIImage(named: "backward"), for: .normal)
        nextButton.setImage(UIImage(named: "forward"), for: .normal)
        lastButton.setImage(UIImage(named: "forward.end"), for: .normal)
        firstButton.setImage(UIImage(named: "backward.end"), for: .normal)
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

    @IBAction private func forwTapped(_ sender: Any) {
        presenter.randomTapped()
    }
    
    @IBAction private func firstTapped(_ sender: Any) {
        presenter.forwTapped()
    }
}

// MARK: - DetailsComicViewControllerProtocol

extension DetailsComicViewController: DetailsComicViewControllerProtocol {
    
    func downloaded(comic: XkcdManegerModel) {
        DispatchQueue.main.async {
            self.imageView.downloaded(from: comic.img)
            self.textLabel.text = comic.alt
            self.presenter.currentComic = comic.num
        }
    }
}
