//
//  ForGitTestTests.swift
//  ForGitTestTests
//
//  Created by 김하늘 on 2022/12/23.
//

import XCTest
@testable import ForGitTest

final class ForGitTestTests: XCTestCase {

    // 초기화 코드 작성. 클래스의 각 테스트 함수의 호출 전에 호출됨
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    // 테스트 함수 호출 뒤 호출됨
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // 테스트 케이스 작성
    func testButtonEvent() throws {
        let vc = ViewController()
        vc.buttonEvent()
    }
    
    func testInsertUserInfo() throws {
        // given
        let vc = ViewController()
        let user = User(name: "haneul", age: 24)
        
        // when
        vc.addCustomer(user: user)
        
        // then
        XCTAssertTrue(vc.customers.map { $0.name }.contains(user.name))
    }
    
    // 서버에 잘 올라가는지 테스트하는 것은 본래의 코드를 건드리거나 아래 함수 내에 서버 호출을 직접 해야함
    func testAsyncTask() throws {
        // given
        let vc = ViewController()
        let beforeCustomerCount = vc.customers.count
        
        // expectation이 fulfill되도록 특정 time 만큼 기다리다가 타임아웃되면 런타임 에러
        let promise = expectation(description: "Customer added") // 예상되는 상황 설명
        
        // when
        vc.서버에데이터올리는작업() // 실제로는 서버에 올리는 작업 호출
        
        // then
        if beforeCustomerCount > vc.customers.count { // 실제로는 서버에 비동기적으로 성공 리턴이 왔을 때. 즉 status code가 200일 때
            promise.fulfill()
        } else {
            XCTFail("not changed")
        }
        wait(for: [promise], timeout: 10)
        // 모든 expectaion 이 충족(fulfill)되거나 time out 될 때 까지 테스트 계속 추적
        // 서버를 비동기적으로 받아오는 작업을 기다릴 경우 timeout 시간 만큼 기다려야함
    }
    
    // 연속적 작업에 대한 테스트 -> 나눌 필요가 있음
    func testTwoTaskSuccess() throws {
        // given
        let vc = ViewController()
        let beforeCustomerCount = vc.customers.count
        let promiseUserInfoFetch = expectation(description: "user info fetched") // 예상되는 상황 설명
        let promiseAddCustomer = expectation(description: "customer added") // 예상되는 상황 설명
        
        // when
        vc.fetchUserAge()
        
        // then
        guard let userAge = vc.userInfoAge else {
            XCTFail("User age is nil")
            return
        }
        promiseUserInfoFetch.fulfill()
        vc.addCustomer(user: User(name: "haneul", age: userAge))
        
        if beforeCustomerCount < vc.customers.count {
            promiseAddCustomer.fulfill()
        }
        wait(for: [promiseUserInfoFetch, promiseAddCustomer], timeout: 5)
    }
    
    func testSample() throws {
        // given : 상태
        var result: Bool = false
        var value: Int?
        
        // when : 이런 로직을 실행하면
        result = true
        value = 1
        
        // then : 이렇게 나와야 한다.
        // 1. Boolean
        XCTAssert(result)
        XCTAssertTrue(result) // 결과 값이 true면 성공
        XCTAssertFalse(result) // 결과 값이 false면 성공
        
        // 2. Nill
        XCTAssertNotNil(value)
        XCTAssertNil(value)
        try XCTUnwrap(value) // testSampleUnwrapWithXCTUnwrap 참고
        
        // 3. Comparable
        XCTAssertGreaterThan(1, 0) // 크기비교
        XCTAssertGreaterThanOrEqual(1, 0) // 크거나 같은지
        XCTAssertLessThan(0, 1)
        XCTAssertLessThanOrEqual(0, 1)
        
        // 4. Error
//        XCTAssertThrowsError(<#T##expression: T##T#>) // 에러 발생하면 성공
//        XCTAssertNoThrow(<#T##expression: T##T#>) // 에러 발생하지 않았을 때 성공
        XCTFail("실패") // 실패 던지고 메시지 출력
        
        
    }
    
    func testSampleUnwrap() throws {
        // given
        let value: Int? = nil
        
        // when
        let unwrapped = value! // fatal error
        
        // then
        XCTAssertEqual(unwrapped, 1)
    }
    
    // XCT로 nil unwrapping 하면 nil일 경우 테스트 실패
    func testSampleUnwrapWithXCTUnwrap() throws {
        // given
        let value: Int? = nil
        
        // when
        let unwrapped = try XCTUnwrap(value) // 테스트 실패
        
        // then
        XCTAssertEqual(unwrapped, 1)
    }
    
    func testSampleSkip() throws {
        let statusCode: Int = 400
        let value: Int? = nil
        
        // if 절이 true인 경우 이후 테스트를 실행하지 않음 (Skip)
        try XCTSkipIf(statusCode != 200, "Can't access server")
        XCTAssertNil(value) // 실행되지 않음
    }
    
    // 성능 테스트를 작성. 함수로 시간 측정
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
