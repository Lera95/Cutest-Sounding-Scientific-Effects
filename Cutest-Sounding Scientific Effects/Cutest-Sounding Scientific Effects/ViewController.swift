import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var comicTabelView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private var cellsModels: [ComicCellViewModel] = []
    private var filtredCellsModels: [ComicCellViewModel] = []

    private static let identifier = "Cell"

    var comics = ComicsModel()
    var height: CGFloat = 300.0
    var alert: UIAlertController!
    var networkManeger = NetworkManager()
    var searching = false


    override func viewDidLoad() {
        super.viewDidLoad()
        requestData(searchText: "")
        comicTabelView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.identifier)
        comicTabelView.dataSource = self
        comicTabelView.delegate = self
        searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        filtredCellsModels = cellsModels

    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredCellsModels.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicTabelView.dequeueReusableCell(withIdentifier: ViewController.identifier) else {
            return UITableViewCell()
        }

        cell.textLabel?.text = filtredCellsModels[indexPath.row].jokeTitle
        cell.detailTextLabel?.text = filtredCellsModels[indexPath.row].jokeText

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}


extension ViewController: UISearchBarDelegate {

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
                self.cellsModels = comics.map { ComicCellViewModel( image: UIImage(),
                                                                    jokeTitle: $0.safeTitle,
                                                                    jokeText: $0.title)}
                guard let searchText = searchText else {
                    return
                }
                let cell = searchText.isEmpty ? self.cellsModels : self.cellsModels.filter { $0.jokeTitle.contains(searchText) }
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

