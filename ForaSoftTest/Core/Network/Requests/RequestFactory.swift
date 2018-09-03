import Foundation
import Alamofire

/// Common implementing the factory to create requests
class RequestFactory: AbstractRequestFactory {
    let sessionManager: SessionManager
    let queue: DispatchQueue
    let errorParser: AbstractErrorParser
    
    init(sessionManager: SessionManager = SessionManagerFactory.sessionManager,
         queue: DispatchQueue = DispatchQueue.global(qos: .userInteractive),
         errorParser: AbstractErrorParser = ErrorParser()
        ) {
        self.sessionManager = sessionManager
        self.queue = queue
        self.errorParser = errorParser
    }
}
