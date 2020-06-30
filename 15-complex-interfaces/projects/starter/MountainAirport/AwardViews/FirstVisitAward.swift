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

struct FirstVisitAward: View {
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(0..<3) { i in
          Rectangle()
            .fill(
              LinearGradient(gradient: .init(colors: [Color.green, Color.blue]),
                             startPoint: .init(x: 0, y: 1),
                             endPoint: .init(x: 1, y: 0)
              )
          )
            .frame(width: geometry.size.width * 0.7, height: geometry.size.width * 0.7)
            .rotationEffect(.degrees(Double(i) * 60.0))
        }
        Image(systemName: "airplane")
          .resizable().rotationEffect(.degrees(-90))
          .opacity(0.5)
          .scaleEffect(0.7)
      }
    }
  }
}

#if DEBUG
struct FirstVisitAward_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FirstVisitAward()
        .environment(\.colorScheme, .light)
        .frame(width: 200, height: 200)
      
      FirstVisitAward()
        .environment(\.colorScheme, .dark)
        .frame(width: 200, height: 200)
    }
  }
}
#endif
