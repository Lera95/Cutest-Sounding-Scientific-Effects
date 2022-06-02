import Foundation
import UIKit

protocol ComicsListPresenterProtocol {
    init(view: ComicsViewControllerProtocol, router: RouterProtocol)
    func didSelectedItem(at indexPath: IndexPath)
    func filteredCellsModelsCount() -> Int
    func getViewModel(for indexPath: IndexPath) -> NetworkComicModel
    func searchBarTextDidChange(searchText: String)
    func searchBarCancelButtonClicked()
    func requestData(searchText: String?)
    func searchTextWithTimer(searchText: String)
}

class ComicsListPresenter: ComicsListPresenterProtocol {

    private var comics: [NetworkComicModel] = []
    private var filteredComics: [NetworkComicModel] = []
    private weak var view: ComicsViewControllerProtocol?
    private var router: RouterProtocol?
    private var searchTimer: CutestTimer?

    required init(view: ComicsViewControllerProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
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
        if filteredComics.count == 0 {
            view?.showEmptyMessageLabel()
        } else {
            view?.removeEmptyMessageLabel()
        }
        return filteredComics.count
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
        NetworkManager.shared.getComics(since: 0) { [weak self] result in
            switch result {
            case .success(let comics):
                self?.comics = comics.reversed()
                guard let searchText = searchText else {
                    return
                }
                let cell = searchText.isEmpty ? self?.comics : self?.comics.filter { $0.safeTitle.contains(searchText) }
                guard let cell = cell else { return }
                self?.filteredComics = cell
                self!.view?.reload()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
