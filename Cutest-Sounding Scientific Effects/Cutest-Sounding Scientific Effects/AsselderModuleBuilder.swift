import Foundation
import UIKit

protocol AsselderBuilderProtocol {
    func createComicsListViewController(router: RouterProtocol) -> UIViewController
    func createDetailsComicViewController(with id: Int, router: RouterProtocol) -> UIViewController
}

class AsselderModuleBuilder: AsselderBuilderProtocol {
    
    func createDetailsComicViewController(with id: Int, router: RouterProtocol) -> UIViewController {
        let view = DetailsComicViewController()
        let presenter = DetailsComicViewPresenter(view: view, router: router, id: id)
        view.presenter = presenter
        return view
    }

    func createComicsListViewController(router: RouterProtocol) -> UIViewController {
        let view = ComicsViewController()
        let presenter = ComicsListPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
