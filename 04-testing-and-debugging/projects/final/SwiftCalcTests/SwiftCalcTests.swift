/// Copyright (c) 2026 Razeware LLC
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

import Testing
@testable import SwiftCalc

struct SwiftCalcTests {
  @Test(arguments: [
     ("3", MathOperator.add, "5", "8.0"),
     ("2", .subtract, "7", "-5.0"),
     ("4", .multiply, "2.5", "10.0"),
     ("9", .divide, "3", "3.0")
   ])
  func operation(first: String, operation: MathOperator, second: String, expected: String) {
    let model = CalculatorModel()
    model.addDisplayText(first)
    model.doOperation(operation)
    model.addDisplayText(second)
    model.equals()
    #expect(model.displayText == expected)
  }
  
  @Test func divideByZeroShowsError() {
    let model = CalculatorModel()
    model.addDisplayText("6")
    model.doOperation(.divide)
    model.addDisplayText("0")
    model.equals()
    #expect(model.displayText == "Err: divide by 0")
  }

  @Test func decimalPointAfterResultStartsNewNumber() {
    let model = CalculatorModel()
    model.addDisplayText("3")
    model.doOperation(.add)
    model.addDisplayText("5")
    model.equals()
    model.addDecimalPoint()
    model.addDisplayText("5")
    #expect(model.displayText == "0.5")
  }
}
