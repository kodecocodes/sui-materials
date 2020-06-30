import XCTest
@testable import GameView

final class GameViewTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GameView().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
