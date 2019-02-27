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
        let expectation2 = XCTestExpectation(description: "iban information should be not nil")
        
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
        return "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJtb2tlamltYWkiLCJpc3MiOiJhdXRoX2FwaSIsImV4cCI6MTU1MTI5ODk5MSwianRpIjoiOGtfbUFONW9VMjF2eGoyNUJLczZFaTBCXzZWdzdPYTIiLCJwc3I6cyI6WyJsb2dnZWRfaW4iXSwicHNyOnUiOiI0NTE3NDUiLCJwc3I6c2lkIjoiY3lXZlhsOUtKTURkdmFwaU5JV2FZMG9INUllVHZUT0kiLCJwc3I6YSI6eyJ1c2VyX2lkIjoiNDUxNzQ1In0sImlhdCI6MTU1MTI1NTc5MX0.rfDj0D1h-dE_nPxH31QHKJaJTOKfKztKXbfnSrfKeOMElvQkDMbHiPF5O2WZYXHsrD_4P0Qn71isDKuo8S8AoVrmccxq_caytn9_VOZ_WR06pItgy-sB6UcFlX5TofA4Nf3-CvYuFUoVHjjQofWTOdyR2xmXgIgIPGQ_3J2lDK7gwCcVbcHAbkaWeeo5t1cTzOj3VCuE8oqwdBCtE95F2Qk-3b_AyD5CNw3TM-z6boxKSJQh0yfcFRWdFJxe-kl5-Ksw8hYicv_666mLZniqiuWIKUwzPsSO_AkP8cE_Mn-aLvRWA7myuGRHfGnM0_lxxL_4EHAUSErK23_GEMgIlKinhqskxByigJz8Zb9ahqZPdsrC572Y1YEqz_DKOG6rbYbfrMU15SublEJxOGNZ-A5zRM47W1cVIlnUa--m7Funx_2HThK66uDtGaGIdRQTbvIEsL2IBT00wX7x41bDaM6hJ-D7nI-hRex23lsmQ3yMkRsbLiBgvRbTQw2XosqfBpZtVSGiPCaD2XyYZamgtPaTk0czFyXqDhuKctSewUp2V8VFdwskkqosa90-SLnsEXLtI_ZRL-pM63UhfvUtuhf4e1_Jfsnw1ZshXpnVwJKD6WIX76KB8cplgLt9ZNL3H__HVqUUu7boA9QBvZkkHE7YOpDMSFfPbxlbOtdgD1U"
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
