import Foundation

struct Song: Decodable {
    var id: Int?
    var name: String?
    var albumId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case name = "trackName"
        case albumId = "collectionId"
    }
}
