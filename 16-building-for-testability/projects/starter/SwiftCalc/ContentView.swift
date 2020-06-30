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

import SwiftUI

enum Operator {
  case none
  case add
  case subtract
  case multiply
  case divide
}

extension View {
  public func addButtonBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat = 5) -> some View where S : ShapeStyle {
    return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
  }
}

struct ContentView: View {
  @State private var accumulator = 0.0
  @State private var display = ""
  @State private var memory = 0.0
  @State private var pendingOperation: Operator = .none
  @State private var displayChange = false
  
  func addDisplayText(_ digit: String) {
    if displayChange {
      display = "\(digit)"
      displayChange = false
    } else {
      display += digit
    }
  }
  
  func doOperation(_ op: Operator) {
    let val = Double(display)!
    switch pendingOperation {
    case .none:
      accumulator = val
    case .add:
      accumulator += val
    case .subtract:
      accumulator -= val
    case .multiply:
      accumulator *= val
    case .divide:
      accumulator /= val
    }
    displayChange = true
    pendingOperation = op
    display = "\(accumulator)"
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        HStack {
          if self.display.isEmpty {
            Text("0")
              // Add display identifier
              .padding(.horizontal, 5)
              .frame(maxWidth: .infinity, alignment: .trailing)
              .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(Color.gray))
          } else {
            Text(self.display)
              // Add display identifier
              .padding(.horizontal, 5)
              .frame(maxWidth: .infinity, alignment: .trailing)
              .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(Color.gray))
          }
        }.padding(.bottom).padding(.horizontal, 5)
        if self.memory != 0.0 {
          HStack {
            Spacer()
            Text("\(self.memory)")
              .padding(.horizontal, 5)
              .frame(width: geometry.size.width * 0.85, alignment: .trailing)
              .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2).foregroundColor(Color.gray))
            // Add gesture here
            Text("M")
          }.padding(.bottom).padding(.horizontal, 5)
        }
        
        HStack {
          Button(action: {
            self.memory = 0.0
          }) {
            Text("MC")
              .frame(width: 45, height: 45)
              .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.display = "\(self.memory)"
          }) {
            Text("MR")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            if let val = Double(self.display) {
              self.memory = self.memory + val
              self.display = ""
              self.pendingOperation = .none
            } else {
              // Add Bug Fix Here
              self.display = "Error"
            }
          }) {
            Text("M+")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.display = ""
          }) {
            Text("C")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.display = ""
            self.accumulator = 0.0
            self.memory = 0.0
          }) {
            Text("AC")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
        }.padding(.bottom)
        
        HStack {
          Button(action: {
            let val = Double(self.display)!
            let root = sqrt(val)
            self.display = "\(root)"
          }) {
            Text("√")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("7")
          }) {
            Text("7")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("8")
          }) {
            Text("8")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("9")
          }) {
            Text("9")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.doOperation(.divide)
          }) {
            Text("÷")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
        }.padding(.bottom)
        
        HStack {
          Button(action: {
            self.display = "\(Double.pi)"
          }) {
            Text("π")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("4")
          }) {
            Text("4")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("5")
          }) {
            Text("5")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("6")
          }) {
            Text("6")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.doOperation(.multiply)
          }) {
            Text("x")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
        }.padding(.bottom)
        
        HStack {
          Button(action: {
            let val = Double(self.display)!
            let root = 1.0 / val
            self.display = "\(root)"
          }) {
            Text("1/x")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("1")
          }) {
            Text("1")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("2")
          }) {
            Text("2")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("3")
          }) {
            Text("3")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.doOperation(.subtract)
          }) {
            Text("-")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
        }.padding(.bottom)
        
        HStack {
          Button(action: {
            let val = Double(self.display)!
            self.display =  "\(-val)"
          }) {
            Text("±")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            if !self.display.contains(".") {
              self.addDisplayText(".")
            }
          }) {
            Text(".")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.addDisplayText("0")
          }) {
            Text("0")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.doOperation(.none)
          }) {
            Text("=")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
          Button(action: {
            self.doOperation(.add)
          }) {
            Text("+")
              .frame(width: 45, height: 45)
            .addButtonBorder(Color.gray)
          }
        }.padding(.bottom)
        Spacer()
      }.font(.title)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
