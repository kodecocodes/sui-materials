/// Copyright (c) 2020 Razeware LLC
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
import MapKit

enum FlightDirection {
  case none
  case arrival
  case departure
}

enum FlightStatus: String, CaseIterable {
  case ontime = "On Time"
  case delayed = "Delayed"
  case canceled = "Canceled"
  case landed = "Landed"
  case departed = "Departed"
}

class FlightInformation: NSObject {
  var id: Int
  var airline: String
  var number: String
  var otherAirport: String
  var otherCoordinates: (lat: Double, long: Double)
  var flightTime: Int
  var scheduledTime: Date
  var currentTime: Date?
  var direction: FlightDirection
  var status: FlightStatus
  var gate: String
  var history: [FlightHistory]

  var isCheckInAvailable: Bool {
    direction == .departure && flightStatus != "Departed"
  }

  var localTime: Date {
    currentTime ?? scheduledTime
  }

  var flightName: String {
    "\(airline) \(number)"
  }

  var dirString: String {
    direction == .arrival ? "From" : "To"
  }

  var statusBoardName: String {
    "\(flightName) \(dirString) \(otherAirport)"
  }

  var otherEndTime: Date {
    var multiplier: Int
    if direction == .arrival {
      multiplier = -1
    } else {
      multiplier = 1
    }
    // swiftlint:disable:next force_unwrapping
    return Calendar.current.date(byAdding: .minute, value: multiplier * flightTime, to: currentTime ?? scheduledTime)!
  }

  var departureTime: Date {
    if direction == .arrival {
      return otherEndTime
    } else {
      return localTime
    }
  }

  var arrivalTime: Date {
    if direction == .departure {
      return otherEndTime
    } else {
      return localTime
    }
  }

  var scheduledTimeString: String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    return timeFormatter.string(from: scheduledTime)
  }

  public var currentTimeString: String {
    guard let time = currentTime else { return "N/A" }
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .none
    timeFormatter.timeStyle = .short
    return timeFormatter.string(from: time)
  }

  var localAirportLocation: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: 35.655, longitude: -83.4411)
  }

  var startingAirportLocation: CLLocationCoordinate2D {
    if direction == .arrival {
      return CLLocationCoordinate2D(latitude: otherCoordinates.lat, longitude: otherCoordinates.long)
    } else {
      return localAirportLocation
    }
  }

  var endingAirportLocation: CLLocationCoordinate2D {
    if direction == .arrival {
      return localAirportLocation
    } else {
      return CLLocationCoordinate2D(latitude: otherCoordinates.lat, longitude: otherCoordinates.long)
    }
  }

  var flightStatus: String {
    let now = Date()

    if status == .canceled {
      return status.rawValue
    }

    guard let currentTime = currentTime else {
      fatalError("currentTime can only be nil if status is canceled")
    }

    if direction == .arrival && now > currentTime {
      return "Arrived"
    }
    if direction == .departure && now > currentTime {
      return "Departed"
    }

    return status.rawValue
  }

  var timeDifference: Int {
    guard let actual = currentTime else { return 60 }
    let diff = Calendar.current.dateComponents([.minute], from: scheduledTime, to: actual)
    // swiftlint:disable:next force_unwrapping
    return diff.minute!
  }

  var statusColor: Color {
    if status == .canceled {
      return Color(red: 0.5, green: 0, blue: 0)
    }

    if timeDifference <= 0 {
      return Color(red: 0.0, green: 0.6, blue: 0)
    }

    if timeDifference <= 15 {
      return Color.yellow
    }

    return Color.red
  }

  var timelineColor: UIColor {
    if status == .canceled {
      return UIColor(red: 0.5, green: 0, blue: 0, alpha: 1)
    }

    if timeDifference <= 0 {
      return UIColor(red: 0.0, green: 0.6, blue: 0, alpha: 1)
    }

    if timeDifference <= 15 {
      return UIColor.yellow
    }

    return UIColor.red
  }

  var isToday: Bool {
    Calendar.current.isDateInToday(localTime)
  }

  var terminalName: String {
    gate.hasPrefix("A") ? "A" : "B"
  }

  var gateNumber: Int? {
    let gateNumberString = gate.dropFirst()
    return Int(gateNumberString)
  }

  init(
    recordId: Int,
    airline: String,
    number: String,
    connection: String,
    airportLocation: (lat: Double, long: Double),
    flightTime: Int,
    scheduledTime: Date,
    currentTime: Date?,
    direction: FlightDirection,
    status: FlightStatus,
    gate: String
  ) {
    self.id = recordId
    self.airline = airline
    self.number = number
    self.otherAirport = connection
    self.otherCoordinates = airportLocation
    self.flightTime = flightTime
    self.scheduledTime = scheduledTime
    self.currentTime = currentTime
    self.direction = direction
    self.status = status
    self.gate = gate
    self.history = []
  }
}

extension FlightInformation: Identifiable {
}
