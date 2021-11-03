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

struct FlightList: View {
  var flights: [FlightInformation]
  @Binding var highlightedIds: [Int]

  func rowHighlighted(_ flightId: Int) -> Bool {
    return highlightedIds.contains { $0 == flightId }
  }

  var nextFlightId: Int {
    guard let flight = flights.first(
      where: {
        $0.localTime >= Date()
      }
    ) else {
      // swiftlint:disable:next force_unwrapping
      return flights.last!.id
    }
    return flight.id
  }

  var body: some View {
    ScrollViewReader { scrollProxy in
      List(flights) { flight in
        NavigationLink(
          destination: FlightDetails(flight: flight)) {
          FlightRow(flight: flight)
        }
        .listRowBackground(
          rowHighlighted(flight.id) ? Color.yellow.opacity(0.6) : Color.clear
        )
        // 1
        .swipeActions(edge: .leading) {
          // 2
          HighlightActionView(flightId: flight.id, highlightedIds: $highlightedIds)
        }
      }.onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
          scrollProxy.scrollTo(nextFlightId, anchor: .center)
        }
      }
    }
  }
}

struct FlightList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      FlightList(
        flights: FlightData.generateTestFlights(date: Date()),
        highlightedIds: .constant([15])
      )
    }
  }
}
