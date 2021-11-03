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

struct FlightTerminalMap: View {
  var flight: FlightInformation
  @State private var showPath = false

  let gateAPaths = [
    [
      CGPoint(x: 360, y: 128),
      CGPoint(x: 225, y: 128),
      CGPoint(x: 225, y: 70)
    ],
    [
      CGPoint(x: 360, y: 128),
      CGPoint(x: 172, y: 128),
      CGPoint(x: 172, y: 70)
    ],
    [
      CGPoint(x: 360, y: 128),
      CGPoint(x: 116, y: 128),
      CGPoint(x: 116, y: 70)
    ],
    [
      CGPoint(x: 360, y: 128),
      CGPoint(x: 46, y: 128)
    ],
    [
      CGPoint(x: 360, y: 128),
      CGPoint(x: 116, y: 128),
      CGPoint(x: 116, y: 187),
      CGPoint(x: 46, y: 187)
    ]
  ]

  let gateBPaths = [
    [
      CGPoint(x: 0, y: 128),
      CGPoint(x: 142, y: 128),
      CGPoint(x: 142, y: 70)
    ],
    [
      CGPoint(x: 0, y: 128),
      CGPoint(x: 197, y: 128),
      CGPoint(x: 197, y: 70)
    ],
    [
      CGPoint(x: 0, y: 128),
      CGPoint(x: 252, y: 128),
      CGPoint(x: 252, y: 70)
    ],
    [
      CGPoint(x: 0, y: 128),
      CGPoint(x: 315, y: 128)
    ],
    [
      CGPoint(x: 0, y: 128),
      CGPoint(x: 252, y: 128),
      CGPoint(x: 252, y: 185),
      CGPoint(x: 315, y: 185)
    ]
  ]

  func gatePath(_ proxy: GeometryProxy) -> [CGPoint] {
    if let gateNumber = flight.gateNumber {
      var pathPoints: [CGPoint]
      if flight.terminalName == "A" {
        pathPoints = gateAPaths[gateNumber - 1]
      } else {
        pathPoints = gateBPaths[gateNumber - 1]
      }

      let ratioX = proxy.size.width / 360.0
      let ratioY = proxy.size.height / 480.0
      var points: [CGPoint] = []
      for pnt in pathPoints {
        let newPoint = CGPoint(
          x: pnt.x * ratioX, y: pnt.y * ratioY
        )
        points.append(newPoint)
      }
      return points
    }

    return []
  }

  var mapName: String {
    "terminal-\(flight.terminalName)-map".lowercased()
  }

  var body: some View {
    Image(mapName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .overlay(
        GeometryReader { proxy in
          Path { path in
            // 1
            let walkingPath = gatePath(proxy)
            // 2
            guard walkingPath.count > 1 else { return }
            // 3
            path.addLines(walkingPath)
          }.stroke(Color.white, lineWidth: 3.0)
        }
      )
  }
}

struct FlightTerminalMap_Previews: PreviewProvider {
  static var testGateA: FlightInformation {
    let flight = FlightData.generateTestFlight(date: Date())
    flight.gate = "A3"
    return flight
  }

  static var testGateB: FlightInformation {
    let flight = FlightData.generateTestFlight(date: Date())
    flight.gate = "B4"
    return flight
  }

  static var previews: some View {
    Group {
      FlightTerminalMap(flight: testGateA)
      FlightTerminalMap(flight: testGateB)
    }
  }
}
