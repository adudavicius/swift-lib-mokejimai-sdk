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
        let expectation = XCTestExpectation(description: "Manual Transfer Configuration should be not nil")
        let expectation2 = XCTestExpectation(description: "Manual Transfer Configuration should be not nil")
        
        let mokejimaiRequestHeaders = createMokejimaiRequestHeaders()
        let mokejimaiApiClient = createMokejimaiApiClient(mokejimaiRequestHeaders: mokejimaiRequestHeaders)
        
        
        mokejimaiApiClient.getManualTransferConfiguration().done { awareResponse in
            transferConfigurations = awareResponse.items
            if let items = transferConfigurations {
                items.forEach { print( $0.transferExecutionTime )}
            }
            expectation.fulfill()
            }.catch { error in
                print((error as? PSMokejimaiApiError)?.toJSON() ?? "")
                expectation.fulfill()
        }
        
        
        mokejimaiRequestHeaders.updateHeader(.acceptLanguage("lv"))
        mokejimaiApiClient.getManualTransferConfiguration().done { awareResponse in
            transferConfigurations = awareResponse.items
            if let items = transferConfigurations {
                items.forEach { print( $0.transferExecutionTime )}
            }
            expectation2.fulfill()
            }.catch { error in
                print((error as? PSMokejimaiApiError)?.toJSON() ?? "")
                expectation2.fulfill()
        }
        
        wait(for: [expectation, expectation2], timeout: 677777.0)
        XCTAssertNotNil(transferConfigurations)
    }
    
    func jwtToken() -> String {
        return ""
    }
    
    func createMokejimaiRequestHeaders() -> MokejimaiRequestHeaders {
        return MokejimaiRequestHeaders(headers: [.jwtToken(jwtToken()), .acceptLanguage("en")])
    }
    
    func createMokejimaiApiClient(mokejimaiRequestHeaders: MokejimaiRequestHeaders) -> MokejimaiApiClient {
        let mokejimaiToken = try? decode(jwt: jwtToken())
        let mokejimaiCredentials = MokejimaiApiCredentials(token: mokejimaiToken)
        
        let mokejimaiClient = MokejimaiApiClientFactory
            .createTransferApiClient(mokejimaiRequestHeaders: mokejimaiRequestHeaders,
                                     credentials: mokejimaiCredentials,
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
