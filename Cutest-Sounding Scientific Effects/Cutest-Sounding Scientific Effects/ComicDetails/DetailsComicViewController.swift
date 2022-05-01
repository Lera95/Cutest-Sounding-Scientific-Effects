import UIKit

class DetailsComicViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var randomButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var lastButton: UIButton!
    @IBOutlet private weak var firstButton: UIButton!
    
    private var currentComic = -1
    private var comic: XkcdManegerModel?

    private let titleText = "Find the best or randomize"

    static let identifier = "DetailsComicViewController"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonImage()
        XkcdManeger.shared.getLatest()
        title = titleText
        textLabel.numberOfLines = 0
    }

    func setComicId(with id: Int) {
        currentComic = id
        XkcdManeger.shared.delegate = self
        XkcdManeger.shared.getComic(withID: id)
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
        if currentComic > 1 {
            XkcdManeger.shared.getComic(withID: currentComic - 1)
        }
    }

    @IBAction private func lastTapped(_ sender: Any) {
        XkcdManeger.shared.getComic(withID: XkcdManeger.latest)
    }

    @IBAction private func randomTapped(_ sender: Any) {
        XkcdManeger.shared.getRandom()
    }

    @IBAction private func forwTapped(_ sender: Any) {
        if currentComic < XkcdManeger.latest {
            XkcdManeger.shared.getComic(withID: currentComic + 1)
        }
    }
    
    @IBAction private func firstTapped(_ sender: Any) {
        XkcdManeger.shared.getComic(withID: 1)
    }
}

// MARK: - ComicDelegate

extension DetailsComicViewController : ComicDelegate {

    func didGetComic(comic: XkcdManegerModel) {
        self.comic = comic
        DispatchQueue.main.async {
            self.imageView.downloaded(from: comic.img)
            self.textLabel.text = comic.alt
            self.currentComic = comic.num
        }
    }

    func didFail(error: Error) {
        print(error.localizedDescription)
    }
}
