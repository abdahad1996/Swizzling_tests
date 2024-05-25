//
//  Swizzling_testsTests.swift
//  Swizzling_testsTests
//
//  Created by macbook abdul on 25/05/2024.
//


import XCTest

// Class to be tested
class MyClass {
    @objc dynamic func originalMethod() -> String {
        return "Original method"
    }
}

// Extension to swizzle the method
extension MyClass {
    @objc dynamic func swizzledMethod() -> String {
        return "Swizzled method"
    }
}

class SwizzlingTests: XCTestCase {
    

    fileprivate func doSwizzling() {
        // Swizzle methods
        let originalMethod = class_getInstanceMethod(MyClass.self, #selector(MyClass.originalMethod))
        let swizzledMethod = class_getInstanceMethod(MyClass.self, #selector(MyClass.swizzledMethod))
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
    
    fileprivate func undoSwizzling() {
        // Clean up swizzling
        let originalMethod = class_getInstanceMethod(MyClass.self, #selector(MyClass.originalMethod))
        let swizzledMethod = class_getInstanceMethod(MyClass.self, #selector(MyClass.swizzledMethod))
        method_exchangeImplementations(swizzledMethod!, originalMethod!)
    }
    

    // Test method that should use the swizzled implementation
    func testSwizzledMethod() {
        doSwizzling()
        let myObject = MyClass()
        XCTAssertEqual(myObject.originalMethod(), "Swizzled method")
        undoSwizzling()
    }
    
    // Test method that should use the original implementation
    func testOriginalMethod() {
        let myObject = MyClass()
        XCTAssertEqual(myObject.originalMethod(), "Original method")
    }
}
