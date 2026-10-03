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

struct FlightInfoPanel: View {
  var flight: FlightInformation
  @State private var showTerminal = false
  @State private var mapReady = false
  
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Flight Details")
        .font(.title2)
      if flight.direction == .arrival {
        Text("Arriving at Gate \(flight.gate)")
        Text("Flying from \(flight.otherAirport)")
      } else {
        Text("Departing from Gate \(flight.gate)")
        Text("Flying to \(flight.otherAirport)")
      }
      Text("\(flight.flightStatus) \(flight.localTime.formatted(date: .omitted, time: .shortened))")
      Button {
        withAnimation(
          reduceMotion ? nil : .easeInOut(duration: 0.5)
        ) {
          showTerminal.toggle()
          if !showTerminal {
            mapReady = false
          }
        } completion: {
          mapReady = showTerminal
        }
      } label: {
        Image(systemName: "airplane")
          .rotationEffect(
            showTerminal ? .degrees(90) : .degrees(270)
          )
        HStack {
          Text(
            showTerminal ? "Hide Terminal Map" : "Show Terminal Map"
          )
          .transaction { $0.animation = nil }
        }
      }
      if showTerminal {
        FlightTerminalView(
          flight: flight,
          showStores: mapReady
        )
      }
    }
    .padding()
  }
}

#Preview {
  FlightInfoPanel(
    flight: FlightData.generateTestFlight(date: Date())
  )
}
