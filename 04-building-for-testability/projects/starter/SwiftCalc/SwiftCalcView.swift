/// Copyright (c) 2020 Razeware LLC
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
  public func addButtonBorder<S>(
    _ content: S,
    width: CGFloat = 1,
    cornerRadius: CGFloat = 5
  ) -> some View where S: ShapeStyle {
    return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
  }
}

struct CalcButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 45, height: 45)
      .addButtonBorder(Color.gray)
      .background(
        RadialGradient(
          gradient: Gradient(
            colors: [Color.white, Color.gray]
          ),
          center: .center,
          startRadius: 0,
          endRadius: 80
        )
      )
  }
}

struct SwiftCalcView: View {
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

  func doOperation(_ opr: Operator) {
    let val = Double(display) ?? 0.0
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
    pendingOperation = opr
    display = "\(accumulator)"
  }

  let calculatorColumns = [
    GridItem(.fixed(45), spacing: 10),
    GridItem(.fixed(45), spacing: 10),
    GridItem(.fixed(45), spacing: 10),
    GridItem(.fixed(45), spacing: 10),
    GridItem(.fixed(45), spacing: 10)
  ]

  var body: some View {
    GeometryReader { geometry in
      LazyVStack {
        DisplayView(display: $display)
          .padding(.horizontal, 7)
          .padding()
        if memory != 0.0 {
          MemoryView(memory: $memory, geometry: geometry)
            .padding(.bottom)
            .padding(.horizontal, 5)
        }

        LazyVGrid(columns: calculatorColumns, spacing: 10) {
          Group {
            Button(action: {
              memory = 0.0
            }, label: {
              Text("MC")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              display = "\(memory)"
            }, label: {
              Text("MR")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              if let val = Double(display) {
                memory += val
                display = ""
                pendingOperation = .none
              } else {
                display = ""
              }
            }, label: {
              Text("M+")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              display = ""
            }, label: {
              Text("C")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              display = ""
              accumulator = 0.0
              memory = 0.0
            }, label: {
              Text("AC")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              let val = Double(display) ?? 0.0
              let root = sqrt(val)
              display = "\(root)"
            }, label: {
              Text("√")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("7")
            }, label: {
              Text("7")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("8")
            }, label: {
              Text("8")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("9")
            }, label: {
              Text("9")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              doOperation(.divide)
            }, label: {
              Text("÷")
            })
          }
          .buttonStyle(CalcButtonStyle())

          Group {
            Button(action: {
              display = "\(Double.pi)"
            }, label: {
              Text("π")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("4")
            }, label: {
              Text("4")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("5")
            }, label: {
              Text("5")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("6")
            }, label: {
              Text("6")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              doOperation(.multiply)
            }, label: {
              Text("x")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              let val = Double(display) ?? 0.0
              let root = 1.0 / val
              display = "\(root)"
            }, label: {
              Text("1/x")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("1")
            }, label: {
              Text("1")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("2")
            }, label: {
              Text("2")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              addDisplayText("3")
            }, label: {
              Text("3")
            })
            .buttonStyle(CalcButtonStyle())

            Button(action: {
              doOperation(.subtract)
            }, label: {
              Text("-")
            })
            .buttonStyle(CalcButtonStyle())
          }

          Button(action: {
            let val = Double(display) ?? 0.0
            display = "\(-val)"
          }, label: {
            Text("±")
          })
          .buttonStyle(CalcButtonStyle())

          Button(action: {
            if !display.contains(".") {
              addDisplayText(".")
            }
          }, label: {
            Text(".")
          })
          .buttonStyle(CalcButtonStyle())

          Button(action: {
            addDisplayText("0")
          }, label: {
            Text("0")
          })
          .buttonStyle(CalcButtonStyle())

          Button(action: {
            doOperation(.none)
          }, label: {
            Text("=")
          })
          .buttonStyle(CalcButtonStyle())

          Button(action: {
            doOperation(.add)
          }, label: {
            Text("+")
          })
          .buttonStyle(CalcButtonStyle())
        }
        Spacer()
      }.font(.title)
    }
    .background(
      LinearGradient(
        gradient: Gradient(
          colors: [
            Color(red: 0.161, green: 0.502, blue: 0.725),
            Color(red: 0.427, green: 0.835, blue: 0.98),
            Color.white
          ]
        ),
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftCalcView()
  }
}
