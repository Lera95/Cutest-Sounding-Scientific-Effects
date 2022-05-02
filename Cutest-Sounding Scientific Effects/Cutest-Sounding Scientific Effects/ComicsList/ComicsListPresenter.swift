import Foundation
import UIKit

class ComicsListPresenter {

    private var cellsModels: [NetworkComicModel] = []
    private var filtredCellsModels: [NetworkComicModel] = []
    private var comics = ComicsModel()
    private weak var view: ComicsListViewControllerProtocol?
    
    var searching: Bool = false

    init(view: ComicsListViewControllerProtocol) {
        self.view = view
        self.requestData(searchText: "")
    }
    
    func filtredCellsModelsCount() -> Int {
        return filtredCellsModels.count
    }

    func getViewModel(for row: Int) -> NetworkComicModel {
        filtredCellsModels[row]
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
                self.filtredCellsModels = cell
                self.view?.reload()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
