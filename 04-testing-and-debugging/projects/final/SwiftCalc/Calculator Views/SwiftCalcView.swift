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

import SwiftUI

struct SwiftCalcView: View {
  @State private var calculatorModel = CalculatorModel()
  @Environment(\.colorScheme) private var colorScheme
  
  var backGroundGradientColors: [Color] {
    if colorScheme == .dark {
      [
        Color(red: 0.08, green: 0.33, blue: 0.50),
        Color(red: 0.05, green: 0.18, blue: 0.30),
        Color(red: 0.02, green: 0.05, blue: 0.10)
      ]
    } else {
      [
        Color(red: 0.161, green: 0.502, blue: 0.725),
        Color(red: 0.427, green: 0.835, blue: 0.98),
        Color.white
      ]
    }
  }
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    #if DEBUG
      let _ = Self._printChanges()
    #endif
    let memorySwipe = DragGesture(minimumDistance: 20)
      .onEnded { _ in
        calculatorModel.clearMemory()
      }
    VStack {
      Spacer()
      if calculatorModel.memoryHasValue {
        MemoryView(memory: calculatorModel.memoryText)
          .accessibilityElement(children: .combine)
          .accessibilityIdentifier("memoryDisplay")
          .gesture(memorySwipe)
          .padding(.bottom)
      }
      DisplayView(display: calculatorModel.displayText)
        .padding(.vertical)
      LazyVGrid(columns: columns, spacing: 10) {
        ForEach(CalculatorButtons.list) { button in
          CalculatorKey(button: button) {
            calculatorModel.processKey(button.operation)
          }
        }
      }
    }
    .frame(maxWidth: 500, maxHeight: .infinity)
    .padding(.horizontal, 10)
    .font(.title)
    .frame(maxWidth: .infinity)
    .background(
      LinearGradient(
        gradient: Gradient(
          colors: backGroundGradientColors
        ),
        startPoint: .bottomTrailing,
        endPoint: .topLeading
      )
    )
  }
}

#Preview {
  SwiftCalcView()
}
