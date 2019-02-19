import Foundation
import PromiseKit

class MokejimaiApiRequest {
    let requestEndPoint: MokejimaiApiRequestRouter
    let pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>)
    
    init(pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>), requestEndPoint: MokejimaiApiRequestRouter) {
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
    }
}
