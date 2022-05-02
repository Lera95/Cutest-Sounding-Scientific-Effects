import Foundation

class DetailsComicViewPresenter {

    private var comic: XkcdManagerModel?
    private var currentComic = -1
    private weak var view: DetailsComicViewControllerProtocol?

    init(view: DetailsComicViewControllerProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        XkcdManager.shared.delegate = self
        XkcdManager.shared.getLatest()
    }

    func getCurrentComic() {
        XkcdManager.shared.getComic(withID: currentComic)
    }

    func setComicId(with id: Int) {
        currentComic = id
        getCurrentComic()
    }

    func prevTapped() {
        if currentComic > 1 {
            XkcdManager.shared.getComic(withID: currentComic - 1)
        }
    }

    func lastTapped() {
        XkcdManager.shared.getComic(withID: XkcdManager.latest)
    }

    func randomTapped() {
        XkcdManager.shared.getRandom()
    }

    func forwardTapped() {
        if currentComic < XkcdManager.latest {
            XkcdManager.shared.getComic(withID: currentComic + 1)
        }
    }

    func firstTapped() {
        XkcdManager.shared.getComic(withID: 1)
    }
}

extension DetailsComicViewPresenter: ComicDelegate {

    func didGetComic(comic: XkcdManagerModel) {
        self.comic = comic
        DispatchQueue.main.async {
            self.view?.downloaded(comic: comic)
            self.currentComic = comic.num
        }
    }

    func didFail(error: Error) {
        print(error.localizedDescription)
    }
}
