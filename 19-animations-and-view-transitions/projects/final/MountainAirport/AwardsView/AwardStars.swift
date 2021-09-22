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

struct AwardStars: View {
  var stars: Int = 3

  var body: some View {
    Canvas { gContext, size in
      // 1
      guard let starSymbol = gContext.resolveSymbol(id: 0) else {
        return
      }

      // 1
      let centerOffset = (size.width - (20 * Double(stars))) / 2.0
      // 2
      gContext.translateBy(x: centerOffset, y: size.height / 2.0)
      // 1
      for star in 0..<stars {
        // 2
        let starXPosition = Double(star) * 20.0
        // 3
        let point = CGPoint(x: starXPosition + 8, y: 0)
        // 4
        gContext.draw(starSymbol, at: point, anchor: .leading)
      }
      // 2
    } symbols: {
      // 3
      Image(systemName: "star.fill")
        .resizable()
        .frame(width: 15, height: 15)
        // 4
        .tag(0)
    }
  }
}

struct AwardStars_Previews: PreviewProvider {
  static var previews: some View {
    AwardStars()
  }
}
