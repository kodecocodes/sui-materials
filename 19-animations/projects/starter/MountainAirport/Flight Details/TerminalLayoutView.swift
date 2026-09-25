/// Copyright (c) 2026 Kodeco Inc.
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

struct TerminalLayoutView: View {
  var flight: FlightInformation
  @State private var width: Double = 0
  
  var scaleRatio: Double {
    width / 354.0
  }
  
  var body: some View {
    HStack(spacing: 0) {
      VStack(spacing: 30 * scaleRatio) {
        ForEach(4...5, id: \.self) { gateNumber in
          gate(gateNumber)
        }
      }
      VStack(spacing: 0) {
        HStack(spacing: 18 * scaleRatio) {
          ForEach(
            (1...3).reversed(),
            id: \.self
          ) { gateNumber in
            gate(gateNumber)
          }
        }
        concourse
      }
    }
    .onGeometryChange(for: CGSize.self) { proxy in
      proxy.size
    } action: { newValue in
      width = newValue.width
    }
    .padding(.vertical, 10 * scaleRatio)
    .background {
      terminalBackground
    }
    .environment(
      \.layoutDirection,
       flight.terminal == "A" ? .leftToRight : .rightToLeft
    )
    .drawingGroup()
  }
  
  var building: LinearGradient {
    LinearGradient(
      colors: [Color.airportMountainNear, Color.airportRunway],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  func gate(_ number: Int) -> some View {
    RoundedRectangle(cornerRadius: 8)
      .fill(building)
      .frame(width: 46 * scaleRatio, height: 34 * scaleRatio)
      .overlay {
        Text(number, format: .number)
          .font(.headline)
          .foregroundStyle(Color.white)
      }
  }
  
  var concourse: some View {
    UnevenRoundedRectangle(
      topLeadingRadius: 10,
      bottomLeadingRadius: 45,
      bottomTrailingRadius: 50,
      topTrailingRadius: 0
    )
    .fill(building)
    .frame(height: 150 * scaleRatio)
    .overlay(alignment: .trailing) {
      Text(flight.terminal)
        .font(.system(size: 54, weight: .bold))
        .foregroundStyle(.white.opacity(0.45))
        .padding(.trailing, 30 * scaleRatio)
    }
  }
  
  var terminalBackground: some View {
    LinearGradient(
      colors: [Color.airportSky, Color.airportAirfield],
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

#Preview("Terminal A") {
  var flight = FlightData.generateTestFlight(date: .now)
  flight.gate = "A5"

  return TerminalLayoutView(
    flight: flight
  )
}

#Preview("Terminal B") {
  var flight = FlightData.generateTestFlight(date: .now)
  flight.gate = "B4"
  
  return TerminalLayoutView(
    flight: flight
  )
}
