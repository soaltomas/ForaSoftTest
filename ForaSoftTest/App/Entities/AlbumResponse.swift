import Foundation

struct AlbumResponse: Decodable {
    var resultCount: Int
    var results: [Album]
}
