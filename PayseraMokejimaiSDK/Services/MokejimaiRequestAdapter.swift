import Foundation
import Alamofire
import CommonCrypto

class MokejimaiRequestAdapter: RequestAdapter {
    
    private let mokejimaiRequestHeaders: MokejimaiRequestHeaders
    
    init(mokejimaiRequestHeaders: MokejimaiRequestHeaders) {
        self.mokejimaiRequestHeaders = mokejimaiRequestHeaders
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        mokejimaiRequestHeaders.headers.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.headerKey)
        }
        return urlRequest
    }
}
