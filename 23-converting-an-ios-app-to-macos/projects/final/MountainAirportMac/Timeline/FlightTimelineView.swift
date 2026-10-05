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

struct FlightTimelineView: View {
  var flights: [FlightInformation]
  @State private var visibleFlightIndex = 0

  var body: some View {
    TimelineView(.everyMinute) { context in
      Text(
        "Updated at: \(context.date.formatted(.timeOnly))"
      )
      .font(.callout)

      ScrollViewReader { scrollProxy in
        HStack {
          Button("Previous") {
            visibleFlightIndex -= 1
            let nextFlightId = flights[visibleFlightIndex].id
            scrollProxy.scrollTo(nextFlightId, anchor: .top)
          }
          .disabled(visibleFlightIndex == 0)

          Button("Next") {
            visibleFlightIndex += 1
            let nextFlightId = flights[visibleFlightIndex].id
            scrollProxy.scrollTo(nextFlightId, anchor: .top)
          }
          .disabled(visibleFlightIndex == flights.count - 1)
        }

        GenericTimeline(
          events: flights,
          timeProperty: \.localTime
        ) { flight in
          FlightCardView(
            flight: flight,
            date: context.date
          )
        }
      }
    }
    .padding()
    .navigationTitle("Flight Timeline")
  }
}

#Preview {
  NavigationStack {
    FlightTimelineView(
      flights: FlightData.generateTestFlights(
        date: Date()
      )
      .filter {
        Calendar.current.isDate(
          $0.localTime,
          inSameDayAs: .now
        )
      }
    )
  }
}
