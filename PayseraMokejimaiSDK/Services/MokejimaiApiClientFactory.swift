import Foundation
import Alamofire

public class MokejimaiApiClientFactory {
    
    public static func createTransferApiClient(
        credentials: MokejimaiApiCredentials,
        tokenRefresher: TokenRefresherProtocol? = nil
        ) -> MokejimaiApiClient {
        let sessionManager = SessionManager()
        sessionManager.adapter = MokejimaiRequestAdapter(mokejimaiApiCredentials: credentials)
        
        return MokejimaiApiClient(sessionManager: sessionManager, credentials: credentials, tokenRefresher: tokenRefresher)
    }
}
