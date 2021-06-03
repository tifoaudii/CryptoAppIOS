import UIKit

struct NewsResponse: Codable {
    let type: Int
    let message: String
    let data: [NewsData]
    let hasWarning: Bool

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case message = "Message"
        case data = "Data"
        case hasWarning = "HasWarning"
    }
}

// MARK: - Datum
struct NewsData: Codable {
    let id: String
    let guid: String
    let publishedOn: Int
    let imageurl: String
    let title: String
    let url: String
    let source, body, tags, categories: String
    let upvotes, downvotes, lang: String
    let sourceInfo: SourceInfo

    enum CodingKeys: String, CodingKey {
        case id, guid
        case publishedOn = "published_on"
        case imageurl, title, url, source, body, tags, categories, upvotes, downvotes, lang
        case sourceInfo = "source_info"
    }
}

// MARK: - SourceInfo
struct SourceInfo: Codable {
    let name, lang: String
    let img: String
}


