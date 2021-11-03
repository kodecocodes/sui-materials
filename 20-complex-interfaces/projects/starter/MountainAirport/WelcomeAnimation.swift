/// Copyright (c) 2021 Razeware LLC
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

struct WelcomeAnimation: View {
  private var startTime = Date()
  private let animationLength = 5.0

  var body: some View {
    TimelineView(.animation) { timelineContext in
      Canvas { graphicContext, size in
        guard let planeSymbol = graphicContext.resolveSymbol(id: 0) else {
          return
        }

        // 1
        let timePosition = (timelineContext.date.timeIntervalSince(startTime))
          .truncatingRemainder(dividingBy: animationLength)
        // 2
        let xPosition = timePosition / animationLength * size.width
        // 3
        graphicContext.draw(
          planeSymbol,
          at: .init(x: xPosition, y: size.height / 2.0)
        )
      } symbols: {
        Image(systemName: "airplane")
          .resizable()
          .aspectRatio(1.0, contentMode: .fit)
          .frame(height: 40)
          .tag(0)
      }
    }
  }
}

struct WelcomeAnimation_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeAnimation()
  }
}
