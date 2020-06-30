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

struct AirportMealAward: View {
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Path { path in
          let size = min(geometry.size.width, geometry.size.height)
          let nearLine = size * 0.1
          let farLine = size * 0.9
          let mid = size / 2
          
          path.move(to: .init(x: mid, y: nearLine))
          path.addQuadCurve(
            to: .init(x: farLine, y: mid),
            control: .init(x: size, y: 0))
          path.addQuadCurve(
            to: .init(x: mid, y: farLine),
            control: .init(x: size, y: size))
          path.addQuadCurve(
            to: .init(x: nearLine, y: mid),
            control: .init(x: 0, y: size))
          path.addQuadCurve(
            to: .init(x: mid, y: nearLine),
            control: .init(x: 0, y: 0))
        }
        .fill(
          RadialGradient(
            gradient: .init(colors: [Color.white, Color.yellow]),
            center: .center,
            startRadius: geometry.size.width * 0.05,
            endRadius: geometry.size.width * 0.6)
        )
        Path { path in
          let size = min(geometry.size.width, geometry.size.height)
          let nearLine = size * 0.1
          let farLine = size * 0.9
          
          path.addArc(center: .init(x: nearLine, y: nearLine),
                      radius: size / 2,
                      startAngle: .degrees(90),
                      endAngle: .degrees(0),
                      clockwise: true)
          path.addArc(center: .init(x: farLine, y: nearLine),
                      radius: size / 2,
                      startAngle: .degrees(180),
                      endAngle: .degrees(90),
                      clockwise: true)
          path.addArc(center: .init(x: farLine, y: farLine),
                      radius: size / 2,
                      startAngle: .degrees(270),
                      endAngle: .degrees(180),
                      clockwise: true)
          path.addArc(center: .init(x: nearLine, y: farLine),
                      radius: size / 2,
                      startAngle: .degrees(0),
                      endAngle: .degrees(270),
                      clockwise: true)
          path.closeSubpath()
        }.stroke(Color.orange, lineWidth: 2)
      }
    }
  }
}

struct AirportMealAward_Previews: PreviewProvider {
  static var previews: some View {
    AirportMealAward()
      .frame(width: 200, height: 200)
  }
}
