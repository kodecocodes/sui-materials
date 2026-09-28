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
import Observation

enum MathOperator {
  case add
  case subtract
  case multiply
  case divide
}

enum DisplayState {
  case entering(String)
  case result(Double)
  case error(String)
}

@Observable final class CalculatorModel {
  private var accumulator = 0.0
  private(set) var memory = 0.0
  private var pendingOperation: MathOperator?
  private var state: DisplayState = .entering("")
  
  // MARK: External Displays
  var displayText: String {
    switch state {
    case .entering(let text): text.isEmpty ? "0" : text
    case .result(let number): "\(number)"
    case .error(let message): message
    }
  }
  
  var memoryText: String {
    memory.formatted()
  }
  
  private var displayedNumber: Double? {
    switch state {
    case .entering(let text): Double(text)
    case .result(let number): number
    case .error: nil
    }
  }
  
  private var currentValue: Double {
    displayedNumber ?? 0
  }

  // MARK: Display Methods
  func setDisplay(_ val: Double){
    if val.isFinite {
      state = .result(val)
    } else {
      setError("Err: infinite")
    }
  }

  func setError(_ errorMessage: String? = nil) {
    if let errorMessage = errorMessage {
      state = .error(errorMessage)
    } else {
      state = .error("Error")
    }
    accumulator = 0.0
    pendingOperation = nil
  }
  
  func clearDisplay() {
    state = .entering("")
  }
  
  func fullClear() {
    state = .entering("")
    accumulator = 0.0
    memory = 0.0
    pendingOperation = nil
  }
  
  // MARK: Memory Related Methods
  func addMemory() {
    guard let val = displayedNumber else {
      setError()
      return
    }
    
    memory += val
    state = .entering("")
    pendingOperation = nil
  }
  

  func clearMemory() {
    memory = 0
  }
  
  var memoryHasValue: Bool {
    !memory.isZero
  }

  func recallMemory() {
    setDisplay(memory)
  }
  
  // MARK: Function Methods
  func equals() {
    if !performMathOperations(pendingOperation) {
      return
    }
    setDisplay(accumulator)
    pendingOperation = nil
  }
  
  func negate() {
    setDisplay(-currentValue)
  }

  func reciprocal() {
    if currentValue.isZero {
      setError("Err: Divide 0")
      return
    }
    setDisplay(1 / currentValue)
  }
  
  func squareRoot() {
    if currentValue < 0.0 {
      setError("Err: Invalid input")
      return
    }
    setDisplay(sqrt(currentValue))
  }
  
  // MARK: Math Operations
  func doOperation(_ opr: MathOperator) {
    if !performMathOperations(pendingOperation) {
      return
    }
    pendingOperation = opr
    setDisplay(accumulator)
  }
  

  func performMathOperations(_ mathOperator: MathOperator?) -> Bool {
    switch mathOperator {
    case .add:
      accumulator += currentValue
    case .subtract:
      accumulator -= currentValue
    case .multiply:
      accumulator *= currentValue
    case .divide:
      if currentValue.isZero {
        if accumulator.isZero {
          setError("Err: nan")
          return false
        } else {
          setError("Err: divide by 0")
          return false
        }
      }
      accumulator /= currentValue
    case nil:
      accumulator = currentValue
    }
    return true
  }
  
  // MARK: Key Operations
  func addDisplayText(_ digit: String) {
    if case .entering(let text) = state {
      state = .entering(text + digit)
    } else {
      state = .entering(digit)
    }
  }
  
  func addDecimalPoint() {
    if case .entering(let text) = state {
      if !text.contains(".") {
        state = .entering(text + ".")
      }
    }
  }
  
  func setConstant(_ val: Double) {
    setDisplay(val)
  }
  
  // MARK: Process Keys
  
  func processKey(_ operation: ButtonOperation) {
    if case .error = state {
      if !operation.isValidAfterError {
        return
      }
    }
    
    switch operation {
    case .memoryClear:
      clearMemory()
    case .memoryRecall:
      recallMemory()
    case .memoryAdd:
      addMemory()
    case .clear:
      clearDisplay()
    case .allClear:
      fullClear()
    case .functionSquareRoot:
      squareRoot()
    case .digit(let digit):
      addDisplayText(digit)
    case .mathOperation(let operation):
      doOperation(operation)
    case .constantPi:
      setConstant(Double.pi)
    case .functionReciprocal:
      reciprocal()
    case .functionNegate:
      negate()
    case .decimalPoint:
      addDecimalPoint()
    case .functionEquals:
      equals()
    }
  }
}
