//
//  Swizzling_testsTests.swift
//  Swizzling_testsTests
//
//  Created by macbook abdul on 25/05/2024.
//


import Foundation
import XCTest
import ObjectiveC.runtime

// Network Manager
class NetworkManager {
    @objc dynamic func fetchData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
}



// Extension to add the swizzled method
extension NetworkManager {
    @objc dynamic func swizzled_fetchData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let mockData = "Mock data".data(using: .utf8)
        completion(mockData, nil)
    }
}

// Swizzle function
func swizzleNetworkManager() {
    let originalSelector = #selector(NetworkManager.fetchData)
    let swizzledSelector = #selector(NetworkManager.swizzled_fetchData)
    
    if let originalMethod = class_getInstanceMethod(NetworkManager.self, originalSelector),
       let swizzledMethod = class_getInstanceMethod(NetworkManager.self, swizzledSelector) {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}


class NetworkManagerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Perform method swizzling setup
        swizzleNetworkManager()
    }
    
    override func tearDown() {
        // Clean up after the test
        // You may optionally revert the swizzling here
        super.tearDown()
    }
    
    func testFetchData() {
        // Create a network manager instance
        let networkManager = NetworkManager()
        
        // Create an expectation to wait for the completion handler
        let expectation = self.expectation(description: "Fetch data expectation")
        
        // Call the method that should be swizzled
        networkManager.fetchData(from: URL(string: "https://example.com")!) { (data, error) in
            // This closure should be invoked with mock data due to swizzling
            let mockData = "Mock data".data(using: .utf8)
            
            XCTAssertEqual(mockData,data)
               
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled (or timeout after a certain interval)
        waitForExpectations(timeout: 5, handler: nil)
    }
}

