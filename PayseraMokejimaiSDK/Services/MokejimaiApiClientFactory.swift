import Foundation
import Alamofire

public class MokejimaiApiClientFactory {
    
    public static func createTransferApiClient(
        mokejimaiRequestHeaders: MokejimaiRequestHeaders,
        credentials: MokejimaiApiCredentials,
        tokenRefresher: TokenRefresherProtocol? = nil
        ) -> MokejimaiApiClient {
        let sessionManager = SessionManager()
        sessionManager.adapter = MokejimaiRequestAdapter(mokejimaiRequestHeaders: mokejimaiRequestHeaders)
        
        return MokejimaiApiClient(sessionManager: sessionManager, credentials: credentials, tokenRefresher: tokenRefresher)
    }
}
