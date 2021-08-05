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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  @StateObject var flightInfo = FlightData()

  @SceneStorage("displayState") var displayState: DisplayState = .none
  @SceneStorage("lastViewedFlightID") var lastViewedFlightID: Int?
  @SceneStorage("selectedFlightID") var selectedFlightID: Int?

  var selectedFlight: FlightInformation? {
    if let id = selectedFlightID {
      return flightInfo.getFlightById(id)
    }
    return nil
  }

  var lastViewedFlight: FlightInformation? {
    if let id = lastViewedFlightID {
      return flightInfo.getFlightById(id)
    }
    return nil
  }

  var body: some View {
    NavigationView {
      WelcomeView(flightInfo: flightInfo)

      switch displayState {
      case .none:
        EmptyView()
      case .flightBoard:
        HStack {
          FlightStatusBoard(flights: flightInfo.getDaysFlights(Date()))
          FlightDetails(flight: selectedFlight)
        }
      case .searchFlights:
        SearchFlights(flightData: flightInfo.flights)
      case .awards:
        AwardsView()
      case .lastFlight:
        FlightDetails(flight: lastViewedFlight)
      }
    }
    .navigationTitle("Mountain Airport")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
