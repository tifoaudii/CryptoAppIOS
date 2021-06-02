import UIKit

// MARK: - NewsResponse
struct NewsResponse: Codable {
    let type: Int
    let message: String
    let data: [Datum]
    let hasWarning: Bool

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case message = "Message"
        case data = "Data"
        case hasWarning = "HasWarning"
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id: String
    let guid: String
    let publishedOn: Int
    let imageurl: String
    let title: String
    let url: String
    let source, body, tags, categories: String
    let upvotes, downvotes: String
    let lang: Lang
    let sourceInfo: SourceInfo

    enum CodingKeys: String, CodingKey {
        case id, guid
        case publishedOn = "published_on"
        case imageurl, title, url, source, body, tags, categories, upvotes, downvotes, lang
        case sourceInfo = "source_info"
    }
}

enum Lang: String, Codable {
    case en = "EN"
}

// MARK: - SourceInfo
struct SourceInfo: Codable {
    let name: String
    let lang: Lang
    let img: String
}

