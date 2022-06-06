import Foundation
import UIKit

protocol ComicsListPresenterProtocol {
    func didSelectedItem(at indexPath: IndexPath)
    func filteredCellsModelsCount() -> Int
    func getViewModel(for indexPath: IndexPath) -> NetworkComicModel
    func searchBarTextDidChange(searchText: String)
    func searchBarCancelButtonClicked()
    func requestData(searchText: String?)
    func searchTextWithTimer(searchText: String)
    func viewDidLoad()
}

class ComicsListPresenter: ComicsListPresenterProtocol {

    private var filteredComics: [NetworkComicModel] = []
    private weak var view: ComicsViewControllerProtocol?
    private var router: RouterProtocol?
    private var searchTimer: CutestTimer?
    private var networkManager: NetworkManagerProtocol

    required init(view: ComicsViewControllerProtocol,
                  router: RouterProtocol,
                  networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }

    func viewDidLoad() {
        self.requestData(searchText: "")
    }

    func searchTextWithTimer(searchText: String) {
        searchTimer = CutestTimer()
        searchTimer?.start(withTimeInterval: 1, onFire: {
            self.searchBarTextDidChange(searchText: searchText)
        })
    }

    func didSelectedItem(at indexPath: IndexPath) {
        view?.deselectRow(at: indexPath)
        router?.showDetailsViewController(at: indexPath)
    }

    func filteredCellsModelsCount() -> Int {
        filteredComics.count
    }

    func getViewModel(for indexPath: IndexPath) -> NetworkComicModel {
        filteredComics[indexPath.row]
    }
    
    func searchBarTextDidChange(searchText: String) {
        requestData(searchText: searchText)
    }

    func searchBarCancelButtonClicked() {
        requestData(searchText: "")
        view?.clearSearchText()
    }

    func requestData(searchText: String?) {
        networkManager.getComics(since: 0) { [weak self] result in
            switch result {
            case .success(let comics):
                self?.filteredComics = comics.reversed()
                guard let searchText = searchText else {
                    return
                }
                let comics = searchText.isEmpty ? self?.filteredComics : self?.filteredComics.filter { $0.safeTitle.contains(searchText) }
                guard let comics = comics else { return }
                self?.filteredComics = comics
                self?.emptyPlaceHolder(filteredComics: self?.filteredComics ?? [])
                self!.view?.reload()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func emptyPlaceHolder(filteredComics: [NetworkComicModel]) {
        DispatchQueue.main.async { [weak self] in
            if filteredComics.isEmpty {
                self?.view?.showEmptyMessageLabel()
            } else {
                self?.view?.removeEmptyMessageLabel()
            }
        }
    }
}
