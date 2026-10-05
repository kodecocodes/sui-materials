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

struct DepartureTimeView: View {
  var flight: FlightInformation

  var body: some View {
    VStack(alignment: .leading) {
      if flight.direction == .arrival {
        Text(flight.otherAirport)
      }
      Text(flight.departureTime, format: .timeOnly)
    }
  }
}

struct ArrivalTimeView: View {
  var flight: FlightInformation

  var body: some View {
    VStack(alignment: .trailing) {
      if flight.direction == .departure {
        Text(flight.otherAirport)
      }
      Text(flight.arrivalTime, format: .timeOnly)
    }
  }
}

struct FlightProgressView: View {
  var flight: FlightInformation
  var progress: CGFloat

  var body: some View {
    Image(systemName: "airplane")
      .resizable()
      .scaledToFit()
      .frame(width: 30, height: 30)
      .foregroundStyle(flight.statusColor)
      .frame(maxWidth: .infinity, alignment: .leading)
      .visualEffect { content, proxy in
        content
          .offset(x: proxy.size.width * progress)
      }
      .padding([.trailing], 32)
  }
}

struct FlightCardView: View {
  var flight: FlightInformation
  var date = Date.now
  var showMap = true
  
  func minutesBetween(_ start: Date, and end: Date) -> Int {
    let diff = Calendar.current.dateComponents(
      [.minute], from: start, to: end
    )
    guard let minute = diff.minute else {
      return 0
    }
    return abs(minute)
  }
  
  func flightTimeFraction(flight: FlightInformation, date now: Date) -> CGFloat {
    if flight.direction == .departure {
      if flight.localTime > now {
        return 0.0
      } else if flight.otherEndTime < now {
        return 1.0
      } else {
        let timeInFlight = minutesBetween(
          flight.localTime, and: now
        )
        let fraction =
          Double(timeInFlight) / Double(flight.flightTime)
        return CGFloat(fraction)
      }
    } else {
      if flight.otherEndTime > now {
        return 0.0
      } else if flight.localTime < now {
        return 1.0
      } else {
        let timeInFlight = minutesBetween(
          flight.otherEndTime, and: now
        )
        let fraction =
          Double(timeInFlight) / Double(flight.flightTime)
        return CGFloat(fraction)
      }
    }
  }

  var body: some View {
    VStack {
      HStack(alignment: .top) {
        DepartureTimeView(flight: flight)
        Spacer()
        Text(flight.statusBoardName)
        Spacer()
        ArrivalTimeView(flight: flight)
      }
      FlightProgressView(
        flight: flight,
        progress: flightTimeFraction(
          flight: flight,
          date: date
        )
      )
      if showMap {
          FlightMapView(
            startCoordinate: flight.startingAirportLocation,
            endCoordinate: flight.endingAirportLocation,
            progress: flightTimeFraction(flight: flight, date: date)
          )
        .scaledToFit()
      }
    }
    .padding()
    .background(.regularMaterial, in: .rect(cornerRadius: 20))
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke()
    )
  }
}

#Preview {
  FlightCardView(
    flight: FlightData.generateTestFlight(date: .now)
  )
}
