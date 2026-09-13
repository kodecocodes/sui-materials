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

import Foundation
import Observation

@MainActor
@Observable
final class SavedFlights {
  var savedFlightIds: [Int] {
    didSet {
      defaults?.set(savedFlightStorage, forKey: "SavedFlight")
    }
  }

  private let defaults: UserDefaults?

  var savedFlightStorage: String {
    get { savedFlightIds.map { String($0) }.joined(separator: ",") }
    set { savedFlightIds = newValue.split(separator: ",").compactMap { Int($0) } }
  }

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
    savedFlightIds = (defaults.string(forKey: "SavedFlight") ?? "")
      .split(separator: ",").compactMap { Int($0) }
  }

  convenience init(flightId: Int) {
    self.init(flightIds: [flightId])
  }

  // Preview data stays in memory and never changes the user's stored flights.
  init(flightIds: [Int]) {
    defaults = nil
    savedFlightIds = flightIds
  }

  func isFlightSaved(_ flight: FlightInformation) -> Bool {
    savedFlightIds.contains(flight.id)
  }

  func saveFlight(_ flight: FlightInformation) {
    guard !isFlightSaved(flight) else { return }
    savedFlightIds.append(flight.id)
  }

  func removeSavedFlight(_ flight: FlightInformation) {
    savedFlightIds.removeAll { $0 == flight.id }
  }

  func getSavedFlights() -> [Int] {
    savedFlightIds
  }
}
