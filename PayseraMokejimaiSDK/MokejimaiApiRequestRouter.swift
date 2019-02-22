import Foundation
import Alamofire

public enum MokejimaiApiRequestRouter: URLRequestConvertible {
    
    // MARK: - GET
    case getManualTransferConfiguration()
    
    // MARK: - POST
    
    // MARK: - PUT
    
    // MARK: - Declarations
    static var baseURLString = "https://bank.paysera.com"
    
    private var method: HTTPMethod {
        switch self {
        case .getManualTransferConfiguration( _):
            return .get
        }
    }
    
    private var path: String {
        switch self {
            
        case .getManualTransferConfiguration():
            return "/manual-transfer-configuration/rest/v1/configurations"
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
        let url = try! MokejimaiApiRequestRouter.baseURLString.asURL()
        
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
