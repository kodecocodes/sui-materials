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

struct FirstFlightAward: View {
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        let R = 5.0
        let r = 3.0
        let p = 1.0
        
        let size = min(geometry.size.width, geometry.size.height)
        let ratio = Double(size) / ((R - r) + r * p) / 2.0
        
        var angle = 0
        let maxT = 2880
        var curveClosed = false
        
        var x0: Double = 0
        var y0: Double = 0
        while(angle < maxT && !curveClosed) {
          let theta = Angle.init(degrees: Double(angle)).radians
          let component = ((R + r) / r) * theta
          let x = (R - r) * cos (theta) + r * p * cos(component)
          let y = (R - r) * sin (theta) - r * p * sin(component)

          let xc = x * ratio
          let yc = y * ratio
          if angle == 0 {
            x0 = xc
            y0 = yc
            path.move(to: .init(x: x0, y: y0))
          } else {
            path.addLine(to: .init(x: xc, y: yc))
            if abs(xc - x0) < 0.25 && abs(yc - y0) < 0.25 {
              curveClosed = true
            }
          }
          angle = angle + 1
        }
      }
      .offset(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
        .stroke(Color.red, lineWidth: 1)
    }
  }
}

#if DEBUG
struct FirstFlightAward_Previews: PreviewProvider {
  static var previews: some View {
    FirstFlightAward()
      .frame(width: 380, height: 380)
  }
}
#endif
