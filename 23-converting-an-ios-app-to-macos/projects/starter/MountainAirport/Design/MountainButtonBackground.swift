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

struct MountainButtonBackground: View {
  private struct MountainRidge: Shape {
    func path(in rect: CGRect) -> Path {
      Path { path in
        path.move(to: CGPoint(x: rect.minX, y: rect.height * 0.8))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: rect.width * 0.55, y: rect.height * 0.75))
        path.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.6))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
      }
    }
  }

  var body: some View {
    ZStack {
      Color.airportMountainNear
        .overlay(.black.opacity(0.25))
      
      MountainRidge()
        .fill(.white.opacity(0.08))
      
      MountainRidge()
        .fill(.black.opacity(0.12))
        .scaleEffect(x: -1, y: 0.65, anchor: .bottom)
    }
    .clipShape(RoundedRectangle(cornerRadius: AirportStyle.contentPadding))
  }
}
#Preview {
    MountainButtonBackground()
    .frame(height: 100)
    .padding()
}
