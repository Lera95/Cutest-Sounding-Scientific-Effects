import UIKit

protocol ComicsViewControllerProtocol: AnyObject {
    func reload()
}

class ComicsViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var comicTableView: UITableView!

    private let cellHeight = 50.0
    private let titleText = "Choose your joke"

    private var searchTimer: Timer?
    var presenter: ComicsListPresenterProtocol?

    private static let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleText
        setupTableView()
        setupSearchBar()
    }

    private func setupTableView() {
        comicTableView.register(UITableViewCell.self, forCellReuseIdentifier: ComicsViewController.cellIdentifier)
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

extension ComicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.filteredCellsModelsCount() ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicTableView.dequeueReusableCell(withIdentifier: ComicsViewController.cellIdentifier) else {
            return UITableViewCell()
        }

        cell.textLabel?.text = presenter?.getViewModel(for: indexPath.row).title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comicTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        presenter?.tapOnComicCell(id: indexPath.row)
    }
}

// MARK: - UITableViewDelegate

extension ComicsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
}

// MARK: - UISearchBarDelegate

extension ComicsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTimer?.invalidate()

        guard let searchText = searchBar.text else { return }

        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.presenter?.searchBarTextDidChange(searchText: searchText)
            }
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter?.searchBarCancelButtonClicked()
    }
}

// MARK: - ComicsListViewControllerProtocol

extension ComicsViewController: ComicsViewControllerProtocol {

    func reload() {
        DispatchQueue.main.async {
            self.view.removeBluerLoader()
            self.comicTableView.reloadData()
        }
    }
}

