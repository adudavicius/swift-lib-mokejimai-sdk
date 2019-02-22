//
//  PayseraMokejimaiSDKTests.swift
//  PayseraMokejimaiSDKTests
//
//  Created by Arvydas Dudavicius on 19/02/2019.
//  Copyright © 2019 Arvydas Dudavicius. All rights reserved.
//

import XCTest
import JWTDecode
import PromiseKit

@testable import PayseraMokejimaiSDK

class MokejimaiTokenTestRefresher: TokenRefresherProtocol {
    func refreshToken() -> Promise<Bool> {
        print("is refreshing")
        return Promise<Bool> { $0.reject(PSMokejimaiApiError.unauthorized()) }
    }
    
    func isRefreshing() -> Bool {
        return false
    }
    
    
}

class PayseraMokejimaiSDKTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetManualTransferConfiguration() {
        
        var transferConfigurations: [PSManualTransfer]?
        let expectation = XCTestExpectation(description: "iban information should be not nil")
        
        let mokejimaiApiClient = createMokejimaiApiClient()
        
        
        mokejimaiApiClient.getManualTransferConfiguration().done { awareResponse in
            transferConfigurations = awareResponse.items
            if let items = transferConfigurations {
                print(items.toJSON())
            }
            expectation.fulfill()
            }.catch { error in
                print((error as? PSMokejimaiApiError)?.toJSON() ?? "")
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 677777.0)
        XCTAssertNotNil(transferConfigurations)
    }
    
    func createMokejimaiApiClient() -> MokejimaiApiClient {
        let mokejimaiToken = try? decode(jwt: "paste your active JWT token here")
        
        let mokejimaiCredentials = MokejimaiApiCredentials.init(token: mokejimaiToken, appLocale: "en")
        
        let mokejimaiClient = MokejimaiApiClientFactory
            .createTransferApiClient(credentials: mokejimaiCredentials,
                                     tokenRefresher: MokejimaiTokenTestRefresher())
        
        return mokejimaiClient
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
