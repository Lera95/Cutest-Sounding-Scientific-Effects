import Foundation

protocol ComicDelegate: AnyObject {
    func didGetComic(comic: XkcdManagerModel)
    func didFail(error: Error)
}

class XkcdManager {

    static let shared = XkcdManager()
    weak var delegate: ComicDelegate?

    static var host = "https://xkcd.com"
    static var info = "/info.0.json"

    static var latest = -1

    func getLatest() {
        let url = URL(string: XkcdManager.host + XkcdManager.info)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFail(error: error!)
                return
            }
            do {
                let comic = try JSONDecoder().decode(XkcdManagerModel.self, from: data)
                XkcdManager.latest = comic.num
            }
            catch(let error) {
                self.delegate?.didFail(error: error)
            }
        }
        task.resume()
    }


    func getComic(withID id: Int) {
        let url = URL(string: XkcdManager.host + "/\(id)" + XkcdManager.info)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFail(error: error!)
                return
            }
            do {
                let comic = try JSONDecoder().decode(XkcdManagerModel.self, from: data)
                self.delegate?.didGetComic(comic: comic)
            }
            catch(let error) {
                self.delegate?.didFail(error: error)
            }
        }
        task.resume()
    }

    func getRandom() {
        if XkcdManager.latest > 1 {
            let random = Int.random(in: 1..<XkcdManager.latest)
            let url = URL(string: XkcdManager.host + "/\(random)" + XkcdManager.info)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    self.delegate?.didFail(error: error!)
                    return
                }
                do {
                    let comic = try JSONDecoder().decode(XkcdManagerModel.self, from: data)
                    self.delegate?.didGetComic(comic: comic)
                }
                catch(let error) {
                    self.delegate?.didFail(error: error)
                }
            }
            task.resume()
        }
        else {
            self.delegate?.didFail(error: NSError(domain: "Whoops", code: -1, userInfo: ["desc" : "Obtain latest first"]))
        }

    }

}
