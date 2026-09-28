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

import Foundation

enum ButtonOperation {
  case memoryClear
  case memoryRecall
  case memoryAdd
  case clear
  case allClear
  case constantPi
  case digit(String)
  case decimalPoint
  case mathOperation(MathOperator)
  case functionSquareRoot
  case functionReciprocal
  case functionNegate
  case functionEquals
  
  var isValidAfterError: Bool {
    switch self {
    case .digit, .clear, .allClear, .constantPi, .memoryRecall, .memoryClear:
      return true
    default:
      return false
    }
  }
}

enum KeyKind {
  case digit
  case mathOperator
  case function
  case memory
}

struct CalculatorButton: Identifiable {
  let name: String
  let accessibilityLabel: String
  let operation: ButtonOperation

  var id: String {
    name
  }
  
  var keyKind: KeyKind {
    switch operation {
    case .memoryClear:
        .memory
    case .memoryRecall:
        .memory
    case .memoryAdd:
        .memory
    case .clear:
        .function
    case .allClear:
        .function
    case .constantPi:
        .function
    case .digit:
        .digit
    case .decimalPoint:
        .digit
    case .mathOperation:
        .mathOperator
    case .functionSquareRoot:
        .function
    case .functionReciprocal:
        .function
    case .functionNegate:
        .function
    case .functionEquals:
        .function
    }
  }
}

struct CalculatorButtons {
  static let list = [
    CalculatorButton(
      name: "MC",
      accessibilityLabel: "Clear Memory",
      operation: .memoryClear
    ),
    CalculatorButton(
      name: "MR",
      accessibilityLabel: "Memory Recall",
      operation: .memoryRecall
    ),
    CalculatorButton(
      name: "M+",
      accessibilityLabel: "Add Memory",
      operation: .memoryAdd
    ),
    CalculatorButton(
      name: "C",
      accessibilityLabel: "Clear",
      operation: .clear
    ),
    CalculatorButton(
      name: "AC",
      accessibilityLabel: "Clear All",
      operation: .allClear
    ),
    CalculatorButton(
      name: "√",
      accessibilityLabel: "Square Root",
      operation: .functionSquareRoot
    ),
    CalculatorButton(
      name: "7",
      accessibilityLabel: "Seven",
      operation: .digit("7")
    ),
    CalculatorButton(
      name: "8",
      accessibilityLabel: "Eight",
      operation: .digit("8")
    ),
    CalculatorButton(
      name: "9",
      accessibilityLabel: "Nine",
      operation: .digit("9")
    ),
    CalculatorButton(
      name: "÷",
      accessibilityLabel: "Divide",
      operation: .mathOperation(.divide)
    ),
    CalculatorButton(
      name: "π",
      accessibilityLabel: "pi",
      operation: .constantPi
    ),
    CalculatorButton(
      name: "4",
      accessibilityLabel: "Four",
      operation: .digit("4")
    ),
    CalculatorButton(
      name: "5",
      accessibilityLabel: "Five",
      operation: .digit("5")
    ),
    CalculatorButton(
      name: "6",
      accessibilityLabel: "Six",
      operation: .digit("6")
    ),
    CalculatorButton(
      name: "×",
      accessibilityLabel: "Multiply",
      operation: .mathOperation(.multiply)
    ),
    CalculatorButton(
      name: "1/x",
      accessibilityLabel: "Reciprocal",
      operation: .functionReciprocal
    ),
    CalculatorButton(
      name: "1",
      accessibilityLabel: "One",
      operation: .digit("1")
    ),
    CalculatorButton(
      name: "2",
      accessibilityLabel: "Two",
      operation: .digit("2")
    ),
    CalculatorButton(
      name: "3",
      accessibilityLabel: "Three",
      operation: .digit("3")
    ),
    CalculatorButton(
      name: "−",
      accessibilityLabel: "Subtract",
      operation: .mathOperation(.subtract)
    ),
    CalculatorButton(
      name: "±",
      accessibilityLabel: "Negate",
      operation: .functionNegate
    ),
    CalculatorButton(
      name: ".",
      accessibilityLabel: "Decimal Point",
      operation: .decimalPoint
    ),
    CalculatorButton(
      name: "0",
      accessibilityLabel: "Zero",
      operation: .digit("0")
    ),
    CalculatorButton(
      name: "=",
      accessibilityLabel: "Equals",
      operation: .functionEquals
    ),
    CalculatorButton(
      name: "+",
      accessibilityLabel: "Add",
      operation: .mathOperation(.add)
    )
  ]
}
