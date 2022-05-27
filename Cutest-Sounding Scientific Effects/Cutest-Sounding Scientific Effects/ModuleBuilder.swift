import Foundation
import UIKit

protocol Builder {
    static func createComicsListViewController() -> UIViewController
    static func createDetailsComicViewController() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createDetailsComicViewController() -> UIViewController {
        let view = DetailsComicViewController()
        let presenter = DetailsComicViewPresenter(view: view)
        view.presenter = presenter
        return view
    }

    static func createComicsListViewController() -> UIViewController {
        let view = ComicsViewController()
        let presenter = ComicsListPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
