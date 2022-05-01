import UIKit

class ComicsListViewController: UIViewController {

    @IBOutlet private weak var comicTabelView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private var cellsModels: [NetworkComicModel] = []
    private var filtredCellsModels: [NetworkComicModel] = []
    private var searching = false
    private var comics = ComicsModel()
    private var networkManeger = NetworkManager()

    private let cellHeight = 50.0
    
    private let titleText = "Choose your joke"

    private static let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleText
        requestData(searchText: "")
        setupTabelView()
        setupSearchBar()
    }

    private func setupTabelView() {
        comicTabelView.register(UITableViewCell.self, forCellReuseIdentifier: ComicsListViewController.cellIdentifier)
        comicTabelView.dataSource = self
        comicTabelView.delegate = self
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        filtredCellsModels = cellsModels
    }
}

// MARK: - UITableViewDataSource

extension ComicsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredCellsModels.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicTabelView.dequeueReusableCell(withIdentifier: ComicsListViewController.cellIdentifier) else {
            return UITableViewCell()
        }

        cell.textLabel?.text = filtredCellsModels[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comicTabelView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let storyboard = UIStoryboard(name: DetailsComicViewController.identifier, bundle: nil)
        let detailsComicViewController = storyboard.instantiateViewController(withIdentifier: DetailsComicViewController.identifier) as! DetailsComicViewController
        detailsComicViewController.setComicId(with: cellsModels[indexPath.row].id)

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
        searching = true
        requestData(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        requestData(searchText: "")
    }

    func requestData(searchText: String?) {
        if searching == false {
            view.showBlurLoader()
        }
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

                DispatchQueue.main.async {
                    self.view.removeBluerLoader()
                    self.comicTabelView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

