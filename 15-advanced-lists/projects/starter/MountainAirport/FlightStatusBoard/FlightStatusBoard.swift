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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct FlightStatusBoard: View {
  var flights: [FlightInformation]
  @State private var hidePast = false
  @AppStorage("FlightStatusCurrentTab") var selectedTab = 1

  var shownFlights: [FlightInformation] {
    hidePast ?
      flights.filter { $0.localTime >= Date() } :
      flights
  }

  var shortDateString: String {
    let dateF = DateFormatter()
    dateF.timeStyle = .none
    dateF.dateFormat = "MMM d"
    return dateF.string(from: Date())
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      FlightList(
        flights: shownFlights.filter { $0.direction == .arrival }
      ).tabItem {
        Image("descending-airplane")
          .resizable()
        Text("Arrivals")
      }
      .badge(shownFlights.filter { $0.direction == .arrival }.count)
      .tag(0)
      FlightList(
        flights: shownFlights
      ).tabItem {
        Image(systemName: "airplane")
          .resizable()
        Text("All")
      }
      .badge(shortDateString)
      .tag(1)
      FlightList(
        flights: shownFlights.filter { $0.direction == .departure }
      ).tabItem {
        Image("ascending-airplane")
        Text("Departures")
      }
      .badge(shownFlights.filter { $0.direction == .departure }.count)
      .tag(2)
    }.navigationTitle("Flight Status")
    .navigationBarItems(
      trailing: Toggle(
        "Hide Past",
        isOn: $hidePast
      )
    )
  }
}

struct FlightStatusBoard_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      FlightStatusBoard(
        flights: FlightData.generateTestFlights(date: Date())
      )
    }
  }
}
