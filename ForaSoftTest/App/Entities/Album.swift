import Foundation
import UIKit

struct Album: Decodable {
    var artistId: Int
    var id: Int
    var artistName: String
    var name: String
    var artworkUrl: URL
    var artwork: UIImageView? = UIImageView()
    var price: Float
    var trackCount: Int
    var copyright: String
    var country: String
    var currency: String
    var releaseDate: String
    var genre: String
    
    enum CodingKeys: String, CodingKey {
        case artistId
        case artistName
        case trackCount
        case copyright
        case country
        case currency
        case releaseDate
        case id = "collectionId"
        case name = "collectionName"
        case artworkUrl = "artworkUrl100"
        case price = "collectionPrice"
        case genre = "primaryGenreName"
    }
}
