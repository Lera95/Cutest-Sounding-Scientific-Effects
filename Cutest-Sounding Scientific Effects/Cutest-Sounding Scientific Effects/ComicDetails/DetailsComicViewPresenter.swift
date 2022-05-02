import Foundation

class DetailsComicViewPresenter {

    private var comic: XkcdManegerModel?
    private weak var view: DetailsComicViewControllerProtocol?
    var currentComic = -1

    init(view: DetailsComicViewControllerProtocol) {
        self.view = view
        XkcdManeger.shared.delegate = self
        XkcdManeger.shared.getLatest()
    }

    func getCurrrentComic() {
            XkcdManeger.shared.getComic(withID: currentComic)
    }

    func prevTapped() {
        if currentComic > 1 {
            XkcdManeger.shared.getComic(withID: currentComic - 1)
        }
    }

    func lastTapped() {
        XkcdManeger.shared.getComic(withID: XkcdManeger.latest)
    }

    func randomTapped() {
        XkcdManeger.shared.getRandom()
    }

    func forwTapped() {
        if currentComic < XkcdManeger.latest {
            XkcdManeger.shared.getComic(withID: currentComic + 1)
        }
    }

    func firstTapped() {
        XkcdManeger.shared.getComic(withID: 1)
    }
}

extension DetailsComicViewPresenter: ComicDelegate {

    func didGetComic(comic: XkcdManegerModel) {
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
