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

struct FlightList: View {
  var flights: [FlightInformation]
  var flightToShow: FlightInformation?
  @State private var path: [FlightInformation] = []
  @State private var allowAutoNavigation = true
  @Environment(AppEnvironment.self) private var appEnvironment
  @State private var showInspector = false

  var selectedFlight: FlightInformation? {
    flights.first { $0.id == appEnvironment.lastFlightId }
  }

  var nextFlightId: Int {
    guard
      let flight = flights.first(
        where: {
          $0.localTime >= Date()
        }
      )
    else {
      return flights.last?.id ?? 0
    }
    return flight.id
  }

  func rowHighlighted(_ flightId: Int) -> Bool {
    return appEnvironment.savedFlightIds.contains { $0 == flightId }
  }

  var body: some View {
    @Bindable var bindableAppEnv = appEnvironment

    ScrollViewReader { scrollProxy in
      List(flights, selection: $bindableAppEnv.lastFlightId) { flight in
        FlightRow(flight: flight)
          .tag(flight.id)
      }
      .onAppear {
        if flightToShow != nil, let selectedFlight {
          showInspector = true
          scrollProxy.scrollTo(selectedFlight.id, anchor: .top)
        } else {
          scrollProxy.scrollTo(nextFlightId, anchor: .top)
        }
      }
    }
    .onChange(of: selectedFlight) { _, newValue in
      showInspector = newValue != nil
    }
    .inspector(isPresented: $showInspector) {
      if let selectedFlight {
        FlightDetails(flight: selectedFlight)
          .inspectorColumnWidth(400)
      }
    }
  }
}

#Preview {
  FlightList(
    flights: FlightData.generateTestFlights(date: .now)
  )
  .environment(AppEnvironment())
}
