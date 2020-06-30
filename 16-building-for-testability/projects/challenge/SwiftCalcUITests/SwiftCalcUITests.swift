/// Copyright (c) 2019 Razeware LLC
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
  
  override func setUp() {
    continueAfterFailure = false
  }
  
  func testPressMemoryPlusAtAppStartShowZeroInDisplay() {
    let app = XCUIApplication()
    app.launch()
    
    // 1
    let display = app.staticTexts["display"]
    // 2
    let displayText = display.label
    // 3
    XCTAssert(displayText == "0")
  }
  
  func testAddingTwoDigits() {
    let app = XCUIApplication()
    app.launch()
    
    let threeButton = app.buttons["3"]
    threeButton.tap()
    
    let addButton = app.buttons["+"]
    addButton.tap()
    
    let fiveButton = app.buttons["5"]
    fiveButton.tap()
    
    let equalButton = app.buttons["="]
    equalButton.tap()
    
    let display = app.staticTexts["display"]
    let displayText = display.label
    XCTAssert(displayText == "8.0")
  }
  
  func testSwipeToClearMemory() {
    let app = XCUIApplication()
    app.launch()
    
    let threeButton = app.buttons["3"]
    threeButton.tap()
    let fiveButton = app.buttons["5"]
    fiveButton.tap()
    
    let memoryButton = app.buttons["M+"]
    memoryButton.tap()
    
    let memoryDisplay = app.staticTexts["memoryDisplay"]
    // 1
    XCTAssert(memoryDisplay.exists)
    // 2
    #if targetEnvironment(macCatalyst)
    memoryDisplay.doubleTap()
    #else
    memoryDisplay.swipeLeft()
    #endif
    // 3
    XCTAssertFalse(memoryDisplay.exists)
  }
  
  func testLaunchPerformance() {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
        XCUIApplication().launch()
      }
    }
  }
}
