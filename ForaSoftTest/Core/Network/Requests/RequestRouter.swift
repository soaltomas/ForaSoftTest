import Foundation
import Alamofire


/// Building URLRequest
///
/// - getAlbums: getting the list of albums
/// - getAlbum: get information about the selected album
enum RequestRouter: URLRequestConvertible {
    
    case getAlbums(parameters: Parameters)
    case getAlbum(parameters: Parameters)
    
    static let baseURLString = "https://itunes.apple.com"
    
    var method: HTTPMethod { return .get }
    
    var path: String {
        switch self {
        case .getAlbums:
            return "/search"
        case .getAlbum:
            return "/lookup"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try RequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .getAlbums(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getAlbum(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
