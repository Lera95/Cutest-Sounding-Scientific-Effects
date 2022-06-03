import Foundation

protocol DetailsComicViewPresenterProtocol {

    func viewDidLoad()
    func prevTapped()
    func getCurrentComic()
    func lastTapped()
    func randomTapped()
    func forwardTapped()
    func firstTapped()
    func tap()
}

class DetailsComicViewPresenter: DetailsComicViewPresenterProtocol {

    private var comic: XkcdManagerModel?
    private var currentComic = -1
    private weak var view: DetailsComicViewControllerProtocol?
    private var router: RouterProtocol?
    private var xkcdManager: XkcdManagerProtocol

    init(view: DetailsComicViewControllerProtocol,
                  router: RouterProtocol,
                  id: Int,
         xkcdManager: XkcdManagerProtocol = XkcdManager.shared) {
        self.view = view
        self.router = router
        self.xkcdManager = xkcdManager
        self.setComicId(with: id)
    }


    func viewDidLoad() {
        xkcdManager.delegate = self
        xkcdManager.getLatest()
    }

    func tap() {
        router?.popToRoot()
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
        DispatchQueue.main.async { [weak self] in
            self?.view?.downloaded(comic: comic)
            self?.currentComic = comic.num
        }
    }

    func didFail(error: Error) {
        print(error.localizedDescription)
    }
}
