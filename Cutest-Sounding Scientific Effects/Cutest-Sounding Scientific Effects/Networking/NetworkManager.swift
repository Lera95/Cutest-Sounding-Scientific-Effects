import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func getComics(text: String, completion: @escaping (Result<[NetworkComicModel], XCError>) -> Void)
    func getImageData(_ url: String) -> Data
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.xkcdy.com/"
    
    // MARK: - Getting all commics
    
    func getComics(text: String, completion: @escaping (Result<[NetworkComicModel], XCError>) -> Void) {
        let since = 0
        let endpoint = baseURL + "comics"
        
        guard var components = URLComponents(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "since", value: String(since))
        ]
        
        let url = URLRequest(url: components.url!)
        
        let _ = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let comics = try decoder.decode([NetworkComicModel].self, from: data)
                DispatchQueue.main.async { [weak self] in
                    completion(.success(self?.filterComics(comics: comics, searchText: text) ?? []))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
            }
            
        }.resume()
    }

    private func filterComics(comics: [NetworkComicModel], searchText: String) -> [NetworkComicModel] {
        searchText.isEmpty ? comics : comics.filter { $0.safeTitle.contains(searchText) }
    }
    
    // MARK: - Getting image data for saving in the database

    func getImageData(_ url: String) -> Data {
        guard let url = URL(string: url) else { return Data() }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error.localizedDescription)
        }
        
        return Data()
    }
}
