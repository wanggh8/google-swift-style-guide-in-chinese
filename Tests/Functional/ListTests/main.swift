// RUN: %{swiftc} %s -o %{built_tests_dir}/ListTests
// RUN: %{built_tests_dir}/ListTests --list-tests > %t_list || true
// RUN: %{xctest_checker} %t_list %s
// RUN: %{built_tests_dir}/ListTests --dump-tests-json > %t_json || true
// RUN: %{built_tests_dir}/ListTests --verify %t_json > %t_verify
// RUN: %{xctest_checker} %t_verify verify_json.expected

#if os(Linux) || os(FreeBSD)
    import XCTest
    import Foundation
#else
    import SwiftXCTest
    import SwiftFoundation
#endif

// The JSON output isn't a stable enough format to use FileCheck-style line
// verification directly. Instead, verify the output by deserializing the output 
// a stable representation of the test tree for checking.
if Process.arguments.contains("--verify") {
    func dump(_ value: Any, prefix: String = "") {
        guard let object = value as? [String: Any] else { return print("<<wrong type>>") }
        guard let name = object["name"] as? String else { return print("<<missing name>>") }
        print(prefix + name)
        guard let children = object["tests"] as? [Any] else { return }
        children.forEach {
            dump($0, prefix: prefix + " ")
        }
    }

    let deserialized = try! NSJSONSerialization.jsonObject(with: NSData(contentsOfFile: Process.arguments[2])!)
    dump(deserialized)
    exit(0)
}


class FirstTestCase: XCTestCase {
    static var allTests = {
        return [
                   ("test_foo", test_foo),
                   ("test_bar", test_bar),
        ]
    }()

    // CHECK: ListTests.FirstTestCase/test_foo
    func test_foo() {}

    // CHECK: ListTests.FirstTestCase/test_bar
    func test_bar() {}
}

class SecondTestCase: XCTestCase {
    static var allTests = {
        return [
                   ("test_someMore", test_someMore),
                   ("test_allTheThings", test_allTheThings),
        ]
    }()

    // CHECK: ListTests.SecondTestCase/test_someMore
    func test_someMore() {}

    // CHECK: ListTests.SecondTestCase/test_allTheThings
    func test_allTheThings() {}
}

XCTMain([
            testCase(FirstTestCase.allTests),
            testCase(SecondTestCase.allTests),
            ])
