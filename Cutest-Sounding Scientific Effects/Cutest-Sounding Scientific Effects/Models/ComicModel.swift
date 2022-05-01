import Foundation

// MARK: - ComicModel
struct NetworkComicModel: Codable, Identifiable, Hashable {
    let id: Int
    let publishedAt, news, safeTitle, title: String
    let transcript, alt: String
    let sourceURL, explainURL: String
    let interactiveURL: String?

    enum CodingKeys: String, CodingKey {
        case id, publishedAt, news, safeTitle, title, transcript, alt
        case sourceURL = "sourceUrl"
        case explainURL = "explainUrl"
        case interactiveURL = "interactiveUrl"
    }
}

typealias ComicsModel = [NetworkComicModel]
