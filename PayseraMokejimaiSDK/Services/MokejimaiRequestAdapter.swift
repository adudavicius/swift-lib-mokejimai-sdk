import Foundation
import Alamofire

class MokejimaiRequestAdapter: RequestAdapter {
    private let mokejimaiApiCredentials: MokejimaiApiCredentials
    
    init(mokejimaiApiCredentials: MokejimaiApiCredentials) {
        self.mokejimaiApiCredentials = mokejimaiApiCredentials
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("Bearer " + (mokejimaiApiCredentials.token?.string ?? ""), forHTTPHeaderField: "Authorization")
        urlRequest.setValue(mokejimaiApiCredentials.appLocale, forHTTPHeaderField: "Accept-Language")
        
        return urlRequest
    }
}
