import Foundation
import Alamofire

public enum TransfersApiRouter: URLRequestConvertible {
    
    // MARK: - GET
    case getTransferConfiguration(locale: String)
    
    // MARK: - POST
    
    // MARK: - PUT
    
    // MARK: - Declarations
    static var baseURLString = "https://bank.paysera.com/"
    
    private var method: HTTPMethod {
        switch self {
        case .getTransferConfiguration( _):
            return .get
        }
    }
    
    private var path: String {
        switch self {
            
        case .getTransferConfiguration(let locale):
            return "/\(locale)/rest/v1/accounts/\(accountNumber)/activate"
        }
    }
    
    private var parameters: Parameters? {
        switch self {

            
        default:
            return nil
        }
    }
    
    // MARK: - Method
    public func asURLRequest() throws -> URLRequest {
        let url = try! AccountsApiRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        case (_) where method == .get:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case (_) where method == .post:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case (_) where method == .put:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
