import Foundation
import UIKit

protocol ComicsListPresenterProtocol {
    init(view: ComicsViewControllerProtocol, router: RouterProtocol)
    func tapOnComicCell(id: Int)
    func filteredCellsModelsCount() -> Int
    func getViewModel(for row: Int) -> NetworkComicModel 
    func searchBarTextDidChange(searchText: String)
    func searchBarCancelButtonClicked()
    func requestData(searchText: String?)
}

class ComicsListPresenter: ComicsListPresenterProtocol {

    private var cellsModels: [NetworkComicModel] = []
    private var filteredCellsModels: [NetworkComicModel] = []
    private var comics = ComicsModel()
    private weak var view: ComicsViewControllerProtocol?
    private var router: RouterProtocol?

    required init(view: ComicsViewControllerProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.requestData(searchText: "")
    }

    func tapOnComicCell(id: Int) {
        router?.showDetailsViewController(with: id)
    }

    func filteredCellsModelsCount() -> Int {
        return filteredCellsModels.count
    }

    func getViewModel(for row: Int) -> NetworkComicModel {
        filteredCellsModels[row]
    }
    
    func searchBarTextDidChange(searchText: String) {
        requestData(searchText: searchText)
    }

    func searchBarCancelButtonClicked() {
        requestData(searchText: "")
    }

    func requestData(searchText: String?) {
        NetworkManager.shared.getComics(since: 0) { result in
            switch result {
            case .success(let comics):
                self.comics = comics.reversed()
                self.cellsModels = comics
                guard let searchText = searchText else {
                    return
                }
                let cell = searchText.isEmpty ? self.cellsModels : self.cellsModels.filter { $0.safeTitle.contains(searchText) }
                self.filteredCellsModels = cell
                self.view?.reload()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
