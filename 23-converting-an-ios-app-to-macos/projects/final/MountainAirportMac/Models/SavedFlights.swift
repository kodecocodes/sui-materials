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

class SavedFlights: ObservableObject {
  @Published var savedFlightIds: [Int] = []
  @AppStorage("SavedFlight") var savedFlightStorage = "" {
    didSet {
      savedFlightIds = getSavedFlights()
    }
  }

  init() {
    savedFlightIds = getSavedFlights()
  }

  init(flightId: Int) {
    savedFlightIds = [flightId]
  }

  init(flightIds: [Int]) {
    savedFlightIds = flightIds
  }

  func isFlightSaved(_ flight: FlightInformation) -> Bool {
    let flightIds = savedFlightStorage.split(separator: ",").compactMap { Int($0) }
    let matching = flightIds.filter { $0 == flight.id }
    return matching.isEmpty == false
  }

  func saveFight(_ flight: FlightInformation) {
    if !isFlightSaved(flight) {
      print("Saving flight: \(flight.id)")
      var flights = savedFlightStorage.split(separator: ",").compactMap { Int($0) }
      flights.append(flight.id)
      savedFlightStorage = flights.map { String($0) }.joined(separator: ",")
    }  }

  func removeSavedFlight(_ flight: FlightInformation) {
    if isFlightSaved(flight) {
      print("Removing saved flight: \(flight.id)")
      let flights = savedFlightStorage.split(separator: ",").compactMap { Int($0) }
      let newFlights = flights.filter { $0 != flight.id }
      savedFlightStorage = newFlights.map { String($0) }.joined(separator: ",")
    }
  }

  func getSavedFlights() -> [Int] {
    let flightIds = savedFlightStorage.split(separator: ",").compactMap { Int($0) }
    return flightIds
  }
}
