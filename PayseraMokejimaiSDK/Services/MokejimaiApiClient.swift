import Foundation
import Alamofire
import PromiseKit
import ObjectMapper

public class MokejimaiApiClient {
    
    private let sessionManager: SessionManager
    private let credentials: MokejimaiApiCredentials
    private let tokenRefresher: TokenRefresherProtocol?
    private var requestsQueue = [MokejimaiApiRequest]()
    
    public init(
        sessionManager: SessionManager,
        credentials: MokejimaiApiCredentials,
        tokenRefresher: TokenRefresherProtocol?
        ) {
        self.sessionManager = sessionManager
        self.tokenRefresher = tokenRefresher
        self.credentials = credentials
    }
    
    public func getManualTransferConfiguration() -> Promise<PSMetadataAwareResponse<PSManualTransfer>> {
        let request = createRequest(.getManualTransferConfiguration())
        makeRequest(apiRequest: request)

        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func getManualTransferConfiguration(locale: String) -> Promise<PSMetadataAwareResponse<PSManualTransfer>> {
        let request = createRequest(.getManualTransferConfigurationWith(locale))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    // MARK: - Private request methods
    private func makeRequest(apiRequest: MokejimaiApiRequest) {
        let lockQueue = DispatchQueue(label: String(describing: tokenRefresher), attributes: [])
        lockQueue.sync {
            if let tokenRefresher = tokenRefresher, tokenRefresher.isRefreshing() {
                requestsQueue.append(apiRequest)
            } else {
                sessionManager
                    .request(apiRequest.requestEndPoint)
                    .responseJSON { (response) in
                        let responseData = response.result.value
                        
                        guard let statusCode = response.response?.statusCode else {
                            let error = self.mapError(body: responseData)
                            apiRequest.pendingPromise.resolver.reject(error)
                            return
                        }
                        
                        if statusCode >= 200 && statusCode < 300 {
                            apiRequest.pendingPromise.resolver.fulfill(responseData)
                        } else {
                            let error = self.mapError(body: responseData)
                            if statusCode == 401 {
                                guard let tokenRefresher = self.tokenRefresher else {
                                    apiRequest.pendingPromise.resolver.reject(error)
                                    return
                                }
                                lockQueue.sync {
                                    if self.credentials.hasRecentlyRefreshed() {
                                        self.makeRequest(apiRequest: apiRequest)
                                        return
                                    }
                                    
                                    self.requestsQueue.append(apiRequest)
                                    
                                    if !tokenRefresher.isRefreshing() {
                                        tokenRefresher
                                            .refreshToken()
                                            .done { result in
                                                self.resumeQueue()
                                            }.catch { error in
                                                self.cancelQueue(error: error)
                                        }
                                    }
                                }
                            } else {
                                apiRequest.pendingPromise.resolver.reject(error)
                            }
                        }
                }
            }
        }
    }
    
    private func resumeQueue() {
        for request in requestsQueue {
            makeRequest(apiRequest: request)
        }
        requestsQueue.removeAll()
    }
    
    private func cancelQueue(error: Error) {
        for requests in requestsQueue {
            requests.pendingPromise.resolver.reject(error)
        }
        requestsQueue.removeAll()
    }
    
    private func createPromiseWithArrayResult<T: Mappable>(body: Any) -> Promise<[T]> {
        guard let objects = Mapper<T>().mapArray(JSONObject: body) else {
            return Promise(error: mapError(body: body))
        }
        return Promise.value(objects)
    }
    
    private func createPromise<T: Mappable>(body: Any) -> Promise<T> {
        guard let object = Mapper<T>().map(JSONObject: body) else {
            return Promise(error: mapError(body: body))
        }
        return Promise.value(object)
    }
    
    private func createPromise(body: Any) -> Promise<Any> {
        return Promise.value(body)
    }
    
    private func mapError(body: Any?) -> PSMokejimaiApiError {
        if let apiError = Mapper<PSMokejimaiApiError>().map(JSONObject: body) {
            return apiError
        }
        
        return PSMokejimaiApiError.unknown()
    }
    
    private func createRequest(_ endpoint: MokejimaiApiRequestRouter) -> MokejimaiApiRequest {
        return MokejimaiApiRequest(
            pendingPromise: Promise<Any>.pending(),
            requestEndPoint: endpoint
        )
    }
}
