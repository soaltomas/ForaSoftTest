import Foundation

struct SongResponse: Decodable {
    var resultCount: Int
    var results: [Song]
}
