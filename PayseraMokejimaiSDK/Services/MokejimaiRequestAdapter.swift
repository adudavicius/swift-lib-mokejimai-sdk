import Foundation
import Alamofire
import CommonCrypto

class MokejimaiRequestAdapter: RequestAdapter {
    private let mokejimaiApiCredentials: MokejimaiApiCredentials
    
    init(mokejimaiApiCredentials: MokejimaiApiCredentials) {
        self.mokejimaiApiCredentials = mokejimaiApiCredentials
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + (mokejimaiApiCredentials.token?.string ?? ""), forHTTPHeaderField: "Authorization")
        if let appLocale = mokejimaiApiCredentials.appLocale {
            urlRequest.setValue(appLocale, forHTTPHeaderField: "Accept-Language")
        }
        return urlRequest
    }
}
