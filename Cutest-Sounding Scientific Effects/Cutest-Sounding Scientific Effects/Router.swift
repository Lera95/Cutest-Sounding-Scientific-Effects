import Foundation
import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AsselderBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func popToRoot()
    func showDetailsViewController(at indexPath: IndexPath)
    init(navigationController: UINavigationController, assemblyBuilder: AsselderBuilderProtocol)
}

class Router: RouterProtocol {

    var navigationController: UINavigationController?
    var assemblyBuilder: AsselderBuilderProtocol?

    required init(navigationController: UINavigationController, assemblyBuilder: AsselderBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func initialViewController() {
        if let navigationController = navigationController {
            guard let comicsListViewController = assemblyBuilder?.createComicsListViewController(router: self) else {
                return
            }
            navigationController.viewControllers = [comicsListViewController]
        }
    }

    func showDetailsViewController(at indexPath: IndexPath) {
        if let navigationController = navigationController {
            guard let detailsViewController = assemblyBuilder?.createDetailsComicViewController(with: indexPath.row, router: self) else {
                return
            }
            navigationController.pushViewController(detailsViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

}
