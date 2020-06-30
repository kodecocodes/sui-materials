/// Copyright (c) 2019 Razeware LLC
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

enum FlightDirection {
  case arrival
  case departure
}

enum FlightStatus: String, CaseIterable {
  case ontime = "On Time"
  case delayed = "Delayed"
  case cancelled = "Canceled"
  case landed = "Landed"
  case departed = "Departed"
}

class FlightInformation: NSObject {
  public var id: Int
  public var airline: String
  public var number: String
  public var otherAirport: String
  public var scheduledTime: Date
  public var currentTime: Date?
  public var direction: FlightDirection
  public var status: FlightStatus
  public var gate: String
  public var history: [FlightHistory]
  
  public var scheduledTimeString: String {
    get {
      let timeFormatter = DateFormatter()
      timeFormatter.dateStyle = .none
      timeFormatter.timeStyle = .short
      return timeFormatter.string(from: scheduledTime)
    }
  }
  
  public var currentTimeString: String {
    get {
      guard let time = currentTime else { return "N/A" }
      let timeFormatter = DateFormatter()
      timeFormatter.dateStyle = .none
      timeFormatter.timeStyle = .short
      return timeFormatter.string(from: time)
    }
  }
  
  public var flightStatus: String {
    let now = Date()
    
    if status == .cancelled {
      return status.rawValue
    }
    
    if direction == .arrival && now > currentTime! {
      return "Arrived"
    }
    if direction == .departure && now > currentTime! {
      return "Departed"
    }
    
    return status.rawValue
  }
  
  public var timeDifference: Int {
    get {
      guard let actual = currentTime else { return 60 }
      let diff = Calendar.current.dateComponents([.minute], from: scheduledTime, to: actual)
      return diff.minute!
    }
  }
  
  public var timelineColor: UIColor {
    if status == .cancelled {
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
  
  init(recordId: Int, airline: String, number: String, connection: String, scheduledTime: Date, currentTime: Date?, direction: FlightDirection, status: FlightStatus, gate: String) {
    self.id = recordId
    self.airline = airline
    self.number = number
    self.otherAirport = connection
    self.scheduledTime = scheduledTime
    self.currentTime = currentTime
    self.direction = direction
    self.status = status
    self.gate = gate
    self.history = []
  }
  
  func isRebookAvailable() -> Bool {
    return status == .cancelled
  }
  
  func isCheckInAvailable() -> Bool {
    return direction == .departure &&
      (flightStatus == "On Time" || flightStatus == "Delayed")
  }
  
  static func generateFlights() -> [FlightInformation] {
    var flights = [FlightInformation]()
    
    for idx in 1...30 {
      let newFlight = generateFlight(idx)
      flights.append(newFlight)
    }
    
    return flights
  }
  
  static func generateFlight() -> FlightInformation {
    generateFlight(Int.random(in: 1...30))
  }
  
  static func generateFlight(_ idx: Int) -> FlightInformation {
    let airlines = ["US", "Southeast", "Pacific", "Overland"]
    let airports = ["Charlotte", "Atlanta", "Chicago", "Dallas/Ft. Worth", "Detroit", "Miami", "Nashville", "New York-LGA", "Denver", "Phoenix"]
    let year = Calendar.current.component(.year, from: Date())
    let month = Calendar.current.component(.month, from: Date())
    let day = Calendar.current.component(.day, from: Date())
    
    let airline = airlines[Int.random(in: 0..<airlines.count)]
    let airport = airports[Int.random(in: 0..<airports.count)]
    let number = "\(Int.random(in: 100..<1000))"
    let t = Int.random(in: 0...1) % 2 == 0 ? "A" : "B"
    let gate = "\(t)\(Int.random(in: 1...5))"
    let direction: FlightDirection = idx % 2 == 0 ? .arrival : .departure
    let hour = Int(Float(idx) / 1.75) + 6
    let minute = Int.random(in: 0...11) * 5
    let scheduled = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: 0))!
    let statusRoll = Int.random(in: 0...100)
    var status: FlightStatus
    var newTime: Date?
    if statusRoll < 67 {
      status = .ontime
      newTime = scheduled
    } else if statusRoll < 90 {
      status = .delayed
      newTime = scheduled.addingTimeInterval(Double(Int.random(in: 0...3600)))
    } else {
      status = .cancelled
      newTime = nil
    }
    let newFlight = FlightInformation(recordId: idx, airline: airline, number: number, connection: airport, scheduledTime: scheduled, currentTime: newTime, direction: direction, status: status, gate: gate)
    for daysAgo in (-10)...(-1) {
      let scheduledHour = Int(Float(idx) / 1.75) + 6
      let scheduledMinute = Int.random(in: 0...11) * 5
      let historyDate = Calendar.current.date(byAdding: .day, value: daysAgo, to: scheduled)!
      let scheduledYear = Calendar.current.component(.year, from: historyDate)
      let scheduledMonth = Calendar.current.component(.month, from: historyDate)
      let scheduledDay = Calendar.current.component(.day, from: historyDate)
      let historyScheduled = Calendar.current.date(from: DateComponents(year: scheduledYear, month: scheduledMonth, day: scheduledDay, hour: scheduledHour, minute: scheduledMinute, second: 0))!
      let historyEntry = generateHistory(-daysAgo, id: idx, date: historyDate, direction: direction, scheduled: historyScheduled)
      newFlight.history.insert(historyEntry, at: 0)
    }
    
    return newFlight
  }
  
  static func generateHistory(_ day: Int, id: Int, date: Date,
                              direction: FlightDirection, scheduled: Date) -> FlightHistory {
    let statusRoll = Int.random(in: 0...100)
    var status: FlightStatus
    var newTime: Date?
    if statusRoll < 10 { // Early!
      status = .ontime
      newTime = scheduled.addingTimeInterval(Double(-Int.random(in: 0...600)))
    } else if statusRoll < 67 {
      status = .ontime
      newTime = scheduled
    } else if statusRoll < 90 {
      status = .delayed
      newTime = scheduled.addingTimeInterval(Double(Int.random(in: 0...3600)))
    } else {
      status = .cancelled
      newTime = nil
    }
    
    return FlightHistory(day, id:id, date: date, direction: direction, status: status, scheduledTime: scheduled, actualTime: newTime)
  }
}

extension Array where Element: FlightInformation {
  func arrivals() -> [FlightInformation] {
    self.filter { $0.direction == .arrival }
  }
  
  func departures() -> [FlightInformation] {
    self.filter { $0.direction == .departure }
  }
}
