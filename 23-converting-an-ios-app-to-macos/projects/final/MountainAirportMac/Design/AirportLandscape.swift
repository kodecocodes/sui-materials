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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

/// A small landscape drawn from polygons and an SF Symbol, without image assets.
struct AirportLandscape: View {
  var body: some View {
    Canvas { context, size in
      // Points use a 0...1 coordinate space so the scene scales with its container.
      context.fill(
        polygon([
          CGPoint(x: 0, y: 0.48),
          CGPoint(x: 0.21, y: 0.17),
          CGPoint(x: 0.43, y: 0.48),
          CGPoint(x: 0.69, y: 0.28),
          CGPoint(x: 1, y: 0.53),
          CGPoint(x: 1, y: 1),
          CGPoint(x: 0, y: 1)
        ], in: size),
        with: .color(Color.airportMountainFar)
      )

      context.fill(
        polygon([
          CGPoint(x: 0, y: 0.61),
          CGPoint(x: 0.12, y: 0.46),
          CGPoint(x: 0.36, y: 0.66),
          CGPoint(x: 0.79, y: 0.39),
          CGPoint(x: 1, y: 0.57),
          CGPoint(x: 1, y: 1),
          CGPoint(x: 0, y: 1)
        ], in: size),
        with: .color(Color.airportMountainMiddle)
      )

      context.fill(
        polygon([
          CGPoint(x: 0, y: 0.64),
          CGPoint(x: 0.24, y: 0.75),
          CGPoint(x: 0.55, y: 0.80),
          CGPoint(x: 0.82, y: 0.71),
          CGPoint(x: 1, y: 0.61),
          CGPoint(x: 1, y: 1),
          CGPoint(x: 0, y: 1)
        ], in: size),
        with: .color(Color.airportMountainNear)
      )

      context.fill(
        polygon([
          CGPoint(x: 0, y: 0.94),
          CGPoint(x: 0.52, y: 0.76),
          CGPoint(x: 0.62, y: 0.76),
          CGPoint(x: 1, y: 0.90),
          CGPoint(x: 1, y: 1),
          CGPoint(x: 0, y: 1)
        ], in: size),
        with: .color(Color.airportAirfield)
      )

      context.fill(
        polygon([
          CGPoint(x: 0.55, y: 0.77),
          CGPoint(x: 0.59, y: 0.77),
          CGPoint(x: 0.77, y: 1),
          CGPoint(x: 0.37, y: 1)
        ], in: size),
        with: .color(Color.airportRunway)
      )

      // Runway markings grow towards the viewer to reinforce the perspective.
      for index in 0..<4 {
        let distance = CGFloat(index) / 4
        let top = 0.79 + distance * 0.22
        let width = 0.002 + distance * 0.006
        let height = 0.010 + distance * 0.018
        let marking = CGRect(
          x: (0.57 - width / 2) * size.width,
          y: top * size.height,
          width: width * size.width,
          height: height * size.height
        )
        context.fill(Path(marking), with: .color(.white))
      }

      var airplane = context.resolve(Image(systemName: "airplane.cloud"))
      airplane.shading = .color(AirportStyle.accent)
      var airplaneContext = context
      airplaneContext.translateBy(x: size.width * 0.72, y: size.height * 0.12)
      airplaneContext.rotate(by: .degrees(-15))
      airplaneContext.scaleBy(x: 1.5, y: 1.0)
      let symbolSize = size.width * 0.085
      airplaneContext.draw(
        airplane,
        in: CGRect(
          x: -symbolSize / 2,
          y: -symbolSize / 2,
          width: symbolSize,
          height: symbolSize
        )
      )
    }
    .mask {
      LinearGradient(
        stops: [
          .init(color: .black, location: 0),
          .init(color: .black, location: 0.86),
          .init(color: .clear, location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    }
    .drawingGroup()
  }

  private func polygon(_ points: [CGPoint], in size: CGSize) -> Path {
    Path { path in
      path.addLines(points.map { point in
        CGPoint(x: point.x * size.width, y: point.y * size.height)
      })
      path.closeSubpath()
    }
  }
}

#Preview {
  AirportLandscape()
}
