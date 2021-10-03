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
import GameKit

// Simple generator that wrapps GKRandom from GameKit to produce a seedable
// random number generator. Not heavily tested, but it's enough for sample data
public struct SeededRandomGenerator: RandomNumberGenerator {
  private let gkrandom: GKRandom

  public mutating func next() -> UInt64 {
    // GKRandom produces values in [INT32_MIN, INT32_MAX] range;
    // Therefore we combine to two to produce a 64-bit value.
    let next1 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
    let next2 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
    // 4294967295 = 0xFFFFFFFF; ensures only low 32 bits are used
    return (next1 & 4294967295) | (next2 << 32)
  }

  init(seed: UInt64) {
    self.gkrandom = GKMersenneTwisterRandomSource(seed: seed)
  }

  init() {
    let seed = UInt64.random(in: UInt64.min ... UInt64.max)
    self.gkrandom = GKMersenneTwisterRandomSource(seed: seed)
  }
}

class FlightData: ObservableObject {
  @Published var flights: [FlightInformation] = []
  var canceledFlight: FlightInformation {
    flights.first { $0.status == .canceled }!
  }
  var departingOnTimeFlight: FlightInformation {
    flights.first { $0.status == .ontime && $0.direction == .departure }!
  }

  // Seeded random numbers so the sample data is same each time
  var generator = SeededRandomGenerator(
    seed: UInt64(17173993227352144317)
  )

  init() {
    flights = generateSchedule()
    let historyFlight = flights[0]
    flights[0] = FlightData.generateTestHistory(flight: historyFlight)
  }

  func getFlightById(_ id: Int) -> FlightInformation? {
    return flights.first { $0.id == id }
  }

  func getDaysFlights(_ date: Date) -> [FlightInformation] {
    flights.filter { Calendar.current.isDate($0.localTime, inSameDayAs: date) }
  }

  func generateSchedule() -> [FlightInformation] {
    var flights: [FlightInformation] = []

    for idx in 0...15 {
      // swiftlint:disable:next force_unwrapping
      let day = Calendar.current.date(byAdding: .day, value: idx, to: Date())!
      flights.append(contentsOf: generateFlights(startIndex: idx * 30, date: day, isFuture: idx > 0))
    }

    return flights.sorted {
      $0.localTime < $1.localTime
    }
  }

  func generateFlights(startIndex: Int, date: Date, isFuture: Bool) -> [FlightInformation] {
    (1...30).map { generateFlight($0 + startIndex, date: date, isFuture: isFuture) }
  }

  func generateFlight(date: Date = Date(), isFuture: Bool) -> FlightInformation {
    return generateFlight(1, date: date, isFuture: isFuture)
  }

  // swiftlint:disable:next function_body_length
  func generateFlight(_ idx: Int, date: Date, isFuture: Bool) -> FlightInformation {
    let airlines = ["US", "Southeast", "Pacific", "Overland"]
    let airports = [
      "Charlotte", "Atlanta", "Chicago", "Dallas/Ft. Worth", "Detroit",
      "Miami", "Nashville", "New York-LGA", "Denver", "Phoenix", "Las Vegas"
    ]
    let airportCoordinates = [
      (lat: 35.2144, long: -80.9473), (lat: 33.6407, long: -84.4277),
      (lat: 41.9742, long: -87.9073), (lat: 32.8998, long: -97.0403),
      (lat: 42.2162, long: -83.3554), (lat: 25.7959, long: -80.2871),
      (lat: 36.1263, long: -86.6774), (lat: 40.7769, long: -73.8740),
      (lat: 39.8561, long: -104.6737), (lat: 33.4484, long: -112.0740),
      (lat: 36.0840, long: -115.1537)
    ]
    let flightTime = [70, 60, 105, 135, 95, 125, 65, 105, 190, 225, 255]
    let year = Calendar.current.component(.year, from: date)
    let month = Calendar.current.component(.month, from: date)
    let day = Calendar.current.component(.day, from: date)

    let airline = airlines[Int.random(in: 0..<airlines.count, using: &generator)]
    let airportNum = Int.random(in: 0..<airports.count, using: &generator)
    let airport = airports[airportNum]
    let airportLocation = airportCoordinates[airportNum]
    let time = flightTime[airportNum]
    let number = "\(Int.random(in: 100..<1000, using: &generator))"
    let terminal = Int.random(in: 0...1, using: &generator) % 2 == 0 ? "A" : "B"
    let gate = "\(terminal)\(Int.random(in: 1...5, using: &generator))"
    let direction: FlightDirection = idx % 2 == 0 ? .arrival : .departure
    let hour = Int(Float(idx % 30) / 1.75) + 6
    let minute = Int.random(in: 0...11, using: &generator) * 5
    let scheduled = Calendar.current
      // swiftlint:disable:next force_unwrapping
      .date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: 0))!
    let statusRoll = Int.random(in: 0...100, using: &generator)
    var status: FlightStatus
    var newTime: Date?
    if statusRoll < 67 || isFuture {
      status = .ontime
      newTime = scheduled
    } else if statusRoll < 90 {
      status = .delayed
      newTime = scheduled.addingTimeInterval(Double(Int.random(in: 0...3600, using: &generator)))
    } else {
      status = .canceled
      newTime = nil
    }
    let newFlight = FlightInformation(
      recordId: idx,
      airline: airline,
      number: number,
      connection: airport,
      airportLocation: airportLocation,
      flightTime: time,
      scheduledTime: scheduled,
      currentTime: newTime,
      direction: direction,
      status: status,
      gate: gate
    )
    // swiftlint:disable force_unwrapping
    for daysAgo in (-10)...(-1) {
      let scheduledHour = Int(Float(idx) / 1.75) + 6
      let scheduledMinute = Int.random(in: 0...11, using: &generator) * 5
      let historyDate = Calendar.current.date(byAdding: .day, value: daysAgo, to: scheduled)!
      let scheduledYear = Calendar.current.component(.year, from: historyDate)
      let scheduledMonth = Calendar.current.component(.month, from: historyDate)
      let scheduledDay = Calendar.current.component(.day, from: historyDate)
      let historyScheduled = Calendar.current.date(
        from: DateComponents(
          year: scheduledYear,
          month: scheduledMonth,
          day: scheduledDay,
          hour: scheduledHour,
          minute: scheduledMinute,
          second: 0
        )
      )!
      let historyEntry =
        generateHistory(-daysAgo, id: idx, date: historyDate, direction: direction, scheduled: historyScheduled)
      newFlight.history.insert(historyEntry, at: 0)
    }
    // swiftlint:enable force_unwrapping

    return newFlight
  }

  func generateHistory(
    _ day: Int,
    id: Int,
    date: Date,
    direction: FlightDirection,
    scheduled: Date
  ) -> FlightHistory {
    let statusRoll = Int.random(in: 0...100, using: &generator)
    var status: FlightStatus
    var newTime: Date?
    if statusRoll < 10 { // Early!
      status = .ontime
      newTime = scheduled.addingTimeInterval(Double(-Int.random(in: 0...600, using: &generator)))
    } else if statusRoll < 67 {
      status = .ontime
      newTime = scheduled
    } else if statusRoll < 90 {
      status = .delayed
      newTime = scheduled.addingTimeInterval(Double(Int.random(in: 0...3600, using: &generator)))
    } else {
      status = .canceled
      newTime = nil
    }

    return FlightHistory(
      day,
      id: id,
      date: date,
      direction: direction,
      status: status,
      scheduledTime: scheduled,
      actualTime: newTime
    )
  }

  static func refreshFlights() async -> [FlightInformation] {
    await Task.sleep(3 * 1_000_000_000) // Three seconds
    return FlightData.generateTestFlights(date: Date())
  }

  static func searchFlightsForCity(_ city: String) async -> [FlightInformation] {
    await Task.sleep(3 * 1_000_000_000) // Three seconds

    let flights = FlightData().flights
    guard !city.isEmpty else {
      return flights
    }

    return flights.filter { $0.otherAirport.lowercased().contains(city.lowercased()) }
  }

  static func citiesContaining(_ text: String) -> [String] {
    let cityArray = FlightData().flights.map { $0.otherAirport }
    let matchingCities =
    text.isEmpty ? cityArray : cityArray.filter { $0.contains(text) }
    let citySet = Set(matchingCities)
    return Array(citySet.sorted())
  }

  static func generateTestFlight(date: Date) -> FlightInformation {
    let flightData = FlightData()
    return flightData.flights[0]
  }

  static func generateTestFlights(date: Date) -> [FlightInformation] {
    let flightData = FlightData()
    return flightData.flights
  }

  static func generateTestFlightHistory(date: Date) -> FlightInformation {
    let flightData = FlightData()
    let flight = flightData.flights[0]
    return generateTestHistory(flight: flight)
  }

  static func generateTestHistory(flight: FlightInformation) -> FlightInformation {
    let range = 60 + 15
    for hst in flight.history {
      let difference = (hst.day - 1) * (range / flight.history.count) - 14
      if hst.day == 10 {
        hst.actualTime = nil
        hst.status = .canceled
      } else {
        // swiftlint:disable:next force_unwrapping
        hst.actualTime = Calendar.current.date(byAdding: .minute, value: difference, to: hst.scheduledTime)!
        if difference <= 0 {
          hst.status = .ontime
        } else {
          hst.status = .delayed
        }
      }
    }
    return flight
  }
}
