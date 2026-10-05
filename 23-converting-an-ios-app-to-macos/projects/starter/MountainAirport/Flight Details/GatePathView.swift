/// Copyright (c) 2026 Kodeco Ltd.
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

struct GatePathView: View {
  var gateNumber: Int
  var terminal: String
  @State var width: Double = 0.0
  @State var height: Double = 0.0
  var showPath = true
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  
  let gatePointsH = [0.75, 0.57, 0.39, 0.16, 0.16]
  let gatePointsV = [0.33, 0.33, 0.33, 0.33, 0.67]

  var walkingAnimation: Animation {
    .linear(duration: 3.0)
    .repeatForever(autoreverses: false)
  }
  
  var body: some View {
    Path { path in
      path.move(to: .init(x: width, y: height * gatePointsV[0]))
      for index in 0..<gateNumber {
        let location = CGPoint(
          x: gatePointsH[index] * width,
          y: gatePointsV[index] * height
        )
        path.addLine(to: location)
      }
      let gateLocation = CGPoint(
        x: gateNumber > 3 ? 0.13 * width : gatePointsH[gateNumber - 1] * width,
        y: gateNumber < 4 ? 0.22 * height : gatePointsV[gateNumber - 1] * height
      )
      path.addLine(to: gateLocation)
    }
    .trim(to: showPath ? 1.0 : 0)
    .stroke(Color.primary, lineWidth: 3.0)
    .animation(
      reduceMotion ? nil : walkingAnimation,
      value: showPath
    )
    .environment(
      \.layoutDirection,
       terminal == "A" ? .leftToRight : .rightToLeft
    )
    .onGeometryChange(for: CGSize.self) { proxy in
      proxy.size
    } action: { newValue in
      width = newValue.width
      height = newValue.height
    }
  }
}

#Preview {
  let flight = FlightData.generateTestFlight(date: .now)
  GatePathView(
    gateNumber: flight.gateNumber ?? 5,
    terminal: flight.terminal
  )
}
