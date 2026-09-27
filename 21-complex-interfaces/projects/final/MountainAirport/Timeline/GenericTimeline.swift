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

struct GenericTimeline<Content, T: Identifiable>: View where Content: View {
  // 1
  var events: [T]
  let content: (T) -> Content
  let timeProperty: KeyPath<T, Date>

  // 2
  init(
    events: [T],
    timeProperty: KeyPath<T, Date>,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.events = events
    self.content = content
    self.timeProperty = timeProperty
  }
  
  var earliestHour: Int {
    // 1
    let firstFlight = events.map({
      $0[keyPath: timeProperty]
    }).min()
    // 2
    guard let firstFlight = firstFlight else {
      return 0
    }
    // 3
    return Calendar.current.component(
      .hour,
      from: firstFlight
    )
  }
  
  var latestHour: Int {
    let lastFlight = events.map({
      $0[keyPath: timeProperty]
    }).max()
    guard let lastFlight = lastFlight else {
      return 0
    }
    return Calendar.current.component(
      .hour,
      from: lastFlight
    ) + 1
  }
  
  func eventsInHour(_ hour: Int) -> [T] {
    return events
      .filter {
        let flightHour =
          Calendar.current.component(
            .hour,
            from: $0[keyPath: timeProperty]
          )
        return flightHour == hour
      }
  }
  
  func hourString(_ hour: Int) -> String {
    let tcmp = DateComponents(hour: hour)
    if let time = Calendar.current.date(from: tcmp) {
      return time.formatted(.timeOnly)
    }
    return "Unknown"
  }
  
  // 3
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        // 1
        ForEach(earliestHour..<latestHour, id: \.self) { hour in
          // 2
          let hourEvents = eventsInHour(hour)
          // 3
          Text(hourString(hour))
            .font(.title2)
          // 4
          ForEach(hourEvents) { event in
            content(event)
          }
        }
      }
    }
  }
}

#Preview {
  GenericTimeline(
    events: FlightData.generateTestFlights(
      date: .now
    ),
    timeProperty: \.localTime
  ) { flight in
    FlightCardView(flight: flight)
  }
}
