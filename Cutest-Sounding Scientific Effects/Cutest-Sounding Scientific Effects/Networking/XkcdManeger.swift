import Foundation

protocol ComicDelegate: AnyObject {
    func didGetComic(comic: XkcdManegerModel)
    func didFail(error: Error)
}

class XkcdManeger {

    static let shared = XkcdManeger()
    weak var delegate: ComicDelegate?

    static var host = "https://xkcd.com"
    static var info = "/info.0.json"

    static var latest = -1

    func getLatest() {
        let url = URL(string: XkcdManeger.host + XkcdManeger.info)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFail(error: error!)
                return
            }
            do {
                let comic = try JSONDecoder().decode(XkcdManegerModel.self, from: data)
                XkcdManeger.latest = comic.num
            }
            catch(let error) {
                self.delegate?.didFail(error: error)
            }
        }
        task.resume()
    }


    func getComic(withID id: Int) {
        let url = URL(string: XkcdManeger.host + "/\(id)" + XkcdManeger.info)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFail(error: error!)
                return
            }
            do {
                let comic = try JSONDecoder().decode(XkcdManegerModel.self, from: data)
                self.delegate?.didGetComic(comic: comic)
            }
            catch(let error) {
                self.delegate?.didFail(error: error)
            }
        }
        task.resume()
    }

    func getRandom() {
        if XkcdManeger.latest > 1 {
            let random = Int.random(in: 1..<XkcdManeger.latest)
            let url = URL(string: XkcdManeger.host + "/\(random)" + XkcdManeger.info)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    self.delegate?.didFail(error: error!)
                    return
                }
                do {
                    let comic = try JSONDecoder().decode(XkcdManegerModel.self, from: data)
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
