import Foundation
import Alamofire

/// Implementing the factory to create requests for albums
class AlbumRequestFactory: RequestFactory {
    
    @discardableResult
    func getAlbums(query: String = "a", completion: @escaping (DataResponse<AlbumResponse>) -> Void) -> DataRequest {
        let parameters: Parameters = ["term" : query,
                                      "entity" : "album"]
        return sessionManager.request(RequestRouter.getAlbums(parameters: parameters)).responseCodable(errorParser: errorParser, completion: completion)
    }
    
    @discardableResult
    func getAlbum(albumId: Int, completion: @escaping (DataResponse<SongResponse>) -> Void) -> DataRequest {
        let parameters: Parameters = ["id" : albumId,
                                      "entity" : "song"]
        return sessionManager.request(RequestRouter.getAlbum(parameters: parameters)).responseCodable(errorParser: errorParser, completion: completion)
    }
}
