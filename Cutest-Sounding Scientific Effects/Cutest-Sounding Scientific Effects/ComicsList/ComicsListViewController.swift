import UIKit

protocol ComicsListViewControllerProtocol: AnyObject {
    func reload()
}

class ComicsListViewController: UIViewController {
    
    @IBOutlet private weak var comicTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private let cellHeight = 50.0
    private let titleText = "Choose your joke"
    private lazy var presenter = ComicsListPresenter(view: self)

    private static let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleText
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        comicTableView.register(UITableViewCell.self, forCellReuseIdentifier: ComicsListViewController.cellIdentifier)
        comicTableView.dataSource = self
        comicTableView.delegate = self

        DispatchQueue.main.async {
            self.view.showBlurLoader()
        }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        self.searchBar.showsCancelButton = true
    }
}

// MARK: - UITableViewDataSource

extension ComicsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filteredCellsModelsCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicTableView.dequeueReusableCell(withIdentifier: ComicsListViewController.cellIdentifier) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = presenter.getViewModel(for: indexPath.row).title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comicTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let storyboard = UIStoryboard(name: DetailsComicViewController.identifier, bundle: nil)
        let detailsComicViewController = storyboard.instantiateViewController(withIdentifier: DetailsComicViewController.identifier) as! DetailsComicViewController
        detailsComicViewController.setComicId(with: presenter.getViewModel(for: indexPath.row).id)
        
        self.navigationController?.pushViewController(detailsComicViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ComicsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}

// MARK: - UISearchBarDelegate

extension ComicsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarTextDidChange(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter.searchBarCancelButtonClicked()
    }
}

// MARK: - ComicsListViewControllerProtocol

extension ComicsListViewController: ComicsListViewControllerProtocol {

    func reload() {
        DispatchQueue.main.async {
            self.view.removeBluerLoader()
            self.comicTableView.reloadData()
        }
    }
}

