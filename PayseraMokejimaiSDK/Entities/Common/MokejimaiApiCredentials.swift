import Foundation
import JWTDecode

public class MokejimaiApiCredentials {
    public var token: JWT?
    public var appLocale: String
    
    public init(token: JWT? = nil, appLocale: String) {
        self.token = token
        self.appLocale = appLocale
    }
    
    public func isExpired() -> Bool {
        if let token = token {
            return token.expiresAt!.timeIntervalSinceNow < 120
        }
        return true
    }
    
    public func hasRecentlyRefreshed() -> Bool {
        guard let token = token else {
            return false
        }
        
        return abs(token.issuedAt!.timeIntervalSinceNow) < 15
    }
}
