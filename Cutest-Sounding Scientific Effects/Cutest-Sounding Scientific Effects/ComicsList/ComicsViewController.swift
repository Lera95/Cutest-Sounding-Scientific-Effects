import UIKit

protocol ComicsViewControllerProtocol: AnyObject {
    func reload()
    func clearSearchText()
    func deselectRow(at indexPath: IndexPath)
    func showEmptyMessageLabel()
    func removeEmptyMessageLabel() 
}

class ComicsViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var comicTableView: UITableView!

    private let titleText = L10n.ComicsViewController.title
    private let emptyText = L10n.ComicsViewController.emptyTitle

    var presenter: ComicsListPresenterProtocol!

    private static let cellIdentifier = L10n.ComicsViewController.cellIdentifier

    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleText
        setupTableView()
        setupSearchBar()
    }

    private func setupTableView() {
        comicTableView.register(UITableViewCell.self, forCellReuseIdentifier: ComicsViewController.cellIdentifier)
        comicTableView.keyboardDismissMode = .onDrag

        DispatchQueue.main.async { [weak self] in
            self?.view.showBlurLoader()
        }
    }

    private func setupSearchBar() {
        self.searchBar.showsCancelButton = true
    }
}

// MARK: - UITableViewDataSource

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filteredCellsModelsCount()
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicTableView.dequeueReusableCell(withIdentifier: ComicsViewController.cellIdentifier) else {
            return UITableViewCell()
        }

        cell.textLabel?.text = presenter.getViewModel(for: indexPath).title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectedItem(at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension ComicsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UISearchBarDelegate

extension ComicsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        presenter.searchTextWithTimer(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarCancelButtonClicked()
    }

    func clearSearchText() {
        searchBar.text = ""
    }
}

// MARK: - ComicsListViewControllerProtocol

extension ComicsViewController: ComicsViewControllerProtocol {

    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.view.removeBluerLoader()
            self?.comicTableView.reloadData()
        }
    }

    func deselectRow(at indexPath: IndexPath) {
        comicTableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func showEmptyMessageLabel() {
        self.comicTableView.setEmptyMessage(emptyText)
    }

    func removeEmptyMessageLabel() {
        self.comicTableView.restore()
    }
}

