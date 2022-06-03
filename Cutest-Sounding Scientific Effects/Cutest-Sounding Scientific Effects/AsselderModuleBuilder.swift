import Foundation
import UIKit

protocol AsselderBuilderProtocol {
    func createComicsListViewController(router: RouterProtocol) -> UIViewController
    func createDetailsComicViewController(with id: Int, router: RouterProtocol) -> UIViewController
}

class AsselderModuleBuilder: AsselderBuilderProtocol {
    
    func createDetailsComicViewController(with id: Int, router: RouterProtocol) -> UIViewController {
        let view = DetailsComicViewController()
        let xkcdManager = XkcdManager()
        let presenter = DetailsComicViewPresenter(view: view, router: router, id: id, xkcdManager: xkcdManager)
        view.presenter = presenter
        return view
    }

    func createComicsListViewController(router: RouterProtocol) -> UIViewController {
        let view = ComicsViewController()
        let networkManager = NetworkManager()
        let presenter = ComicsListPresenter(view: view, router: router, networkManager: networkManager)
        view.presenter = presenter
        return view
    }
}
