import Foundation
import UIKit

class ComicsListPresenter {

    private var cellsModels: [NetworkComicModel] = []
    private var filteredCellsModels: [NetworkComicModel] = []
    private var comics = ComicsModel()
    private weak var view: ComicsListViewControllerProtocol?

    init(view: ComicsListViewControllerProtocol) {
        self.view = view
        self.requestData(searchText: "")
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
