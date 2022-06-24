/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest

class SwiftCalcUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPressMemoryPlusAtAppStartShowZeroInDisplay() throws {
        // Given the application launches
        let app = XCUIApplication()
        app.launch()

        // When the memory plus button is tapped
        let memoryButton = app.buttons["M+"]
        memoryButton.tap()
        
        // Then the display should show zero value
        let display = app.staticTexts["display"]
        let displayText = display.label
        XCTAssertEqual(displayText, "0")
    }
    
    func testAddingTwoDigits() {
        // Given the application launches
        let app = XCUIApplication()
        app.launch()
        
        // When the user adds together 3 and 5
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["5"].tap()
        app.buttons["="].tap()
        
        // Then the result should display as 8.0
        XCTAssertEqual(app.staticTexts["display"].label, "8.0")
    }
    
    func testSwipeToClearMemory() {
        // Given the application launches
        let app = XCUIApplication()
        app.launch()
        
        // When the user stores 35 into memory
        app.buttons["3"].tap()
        app.buttons["5"].tap()
        app.buttons["M+"].tap()
        
        // Then the memory display should show
        let memoryDisplay = app.staticTexts["memoryDisplay"]
        XCTAssert(memoryDisplay.exists)
        XCTAssertEqual(memoryDisplay.label, "35.000000")
        
        // And the memory display should disappear
        memoryDisplay.swipeLeft()
        XCTAssertFalse(memoryDisplay.exists)
    }
}
