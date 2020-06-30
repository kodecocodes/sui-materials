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

struct OverNightParkAward: View {
  var body: some View {
    GeometryReader { geometry in
      ZStack{
        Path { path in
          let size = min(geometry.size.width, geometry.size.height)
          let nearLine = size * 0.1
          let farLine = size * 0.9
          
          path.move(to: CGPoint(x: size / 2 + nearLine, y: nearLine))
          path.addLine(to: .init(x: farLine, y: farLine))
          path.addLine(to: .init(x: nearLine, y: farLine))
          path.addLine(to: .init(x: size / 2 - nearLine, y: nearLine))
        }
        .fill(Color.init(red: 0.4, green: 0.4, blue: 0.4))
        Path { path in
          let size = min(geometry.size.width, geometry.size.height)
          let nearLine = size * 0.1
          let farLine = size * 0.9
          //1
          let middle = size / 2
          
          path.move(to: .init(x: middle, y: farLine))
          path.addLine(to: .init(x: middle, y: nearLine))
        }
        .stroke(Color.white,
                style: .init(lineWidth: 3.0, dash: [geometry.size.height / 20, geometry.size.height / 30], dashPhase: 0))
        Image(systemName: "car.fill")
          .resizable()
          .foregroundColor(Color.blue)
          .scaleEffect(0.20)
          .offset(x: -geometry.size.width / 7.25)
      }
    }
  }
}

struct OverNightParkAward_Previews: PreviewProvider {
  static var previews: some View {
    OverNightParkAward()
      .frame(width: 200, height: 200)
  }
}

