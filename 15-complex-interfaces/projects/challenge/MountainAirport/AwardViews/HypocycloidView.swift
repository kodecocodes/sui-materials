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

struct HypocycloidView: View {
  var R: Double
  var r: Double
  var p = 1.0
  var color = Color.red
  
  var awardTitle: String {
    get {
      return "\(self.R):\(self.r):\(self.p)"
    }
  }
  
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        
        let size = min(geometry.size.width, geometry.size.height)
        let ratio = Double(size) / ((self.R - self.r) + self.r * self.p) / 2.0
        
        var angle = 0
        let maxT = 2880
        var curveClosed = false
        
        var x0: Double = 0
        var y0: Double = 0
        while(angle < maxT && !curveClosed) {
          let theta = Angle.init(degrees: Double(angle)).radians
          let component = ((self.R + self.r) / self.r) * theta
          let x = (self.R - self.r) * cos (theta) + self.r * self.p * cos(component)
          let y = (self.R - self.r) * sin (theta) - self.r * self.p * sin(component)
          
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
        .stroke(self.color, lineWidth: 1)
    }
  }
}

#if DEBUG
struct HypocycloidView_Previews: PreviewProvider {
  static var previews: some View {
    HypocycloidView(R: 5, r: 3)
      .frame(width: 250, height: 250)
  }
}
#endif
