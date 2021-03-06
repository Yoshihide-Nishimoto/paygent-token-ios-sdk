//
//  PaygentTests.swift
//  PaygentTests
//
//  Created by Shuhei Kawaguchi on 2017/11/17.
//  Copyright © 2017年 Shuhei Kawaguchi. All rights reserved.
//

import XCTest
@testable import PaygentTokenSDK

class PaygentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardToken() {
        struct TestRequest: PaygentTokenRequest {
            var cardNumber: String
            var cardExpireYear: String
            var cardExpireMonth: String
            var cardCVC: String
            var cardName: String

            init(cardNumber: String, cardExpireYear: String, cardExpireMonth: String, cardCVC: String, cardName: String) {
                self.cardNumber = cardNumber
                self.cardExpireYear = cardExpireYear
                self.cardExpireMonth = cardExpireMonth
                self.cardCVC = cardCVC
                self.cardName = cardName
            }

            var merchantID: String {
                return ""
            }
            var tokenGenerateKey: String {
                return ""
            }
            var isSandbox: Bool {
                return true
            }
        }

        let request = TestRequest(cardNumber: "4900123412341234", cardExpireYear: "18",
                                  cardExpireMonth: "10", cardCVC: "000", cardName: "test")

        let cardTokenExpectation: XCTestExpectation? = self.expectation(description: "paygent card token")
        PaygentSession.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                XCTFail()
            case .failure(let error as SessionTaskError):
                guard case .responseError(let e) = error else { return XCTFail() }
                guard case ResponseError.paygentErrorCode(let code) = e else { return XCTFail() }
                XCTAssertEqual(code, "1200")
            case .failure(_):
                XCTFail()
            }
            cardTokenExpectation?.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCVCToken() {
        struct TestCVCRequest: PaygentCVCTokenRequest {
            var cardCVC: String
            var cvcOnlyFlg: String
            init(cardCVC: String, cvcOnlyFlg: String) {
                self.cardCVC = cardCVC
                self.cvcOnlyFlg = cvcOnlyFlg
            }
            
            var merchantID: String {
                return ""
            }
            var tokenGenerateKey: String {
                return ""
            }
        }
        
        let request = TestCVCRequest(cardCVC: "123", cvcOnlyFlg: "1")
        
        let cvcTokenExpectation: XCTestExpectation? = self.expectation(description: "paygent cvc token")
        PaygentSession.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                XCTFail()
            case .failure(let error as SessionTaskError):
                guard case .responseError(let e) = error else { return XCTFail() }
                guard case ResponseError.paygentErrorCode(let code) = e else { return XCTFail() }
                XCTAssertEqual(code, "1200")
            case .failure(_):
                XCTFail()
            }
            cvcTokenExpectation?.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
