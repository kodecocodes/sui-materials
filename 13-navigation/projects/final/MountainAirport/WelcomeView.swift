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

struct WelcomeView: View {
  @StateObject var flightInfo: FlightData = FlightData()
  @State var showNextFlight = false
  @ObservedObject var lastFlightInfo = FlightNavigationInfo()
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .topLeading) {
        // 2
        Image("welcome-background")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipped()
        VStack(alignment: .leading) {
          if let lastFlightId = lastFlightInfo.lastFlightId,
             let lastFlight = flightInfo.getFlightById(lastFlightId) {
            NavigationLink(
              destination: FlightDetails(flight: lastFlight),
              // 1
              isActive: $showNextFlight
              // 2
            ) { }
          }
          NavigationLink(
            destination: FlightStatusBoard(
              flights: flightInfo.getDaysFlights(Date())
            )
          ) {
            WelcomeButtonView(
              title: "Flight Status",
              subTitle: "Departure and arrival information"
            )
          }
          NavigationLink(
            destination: GenericView()) {
            WelcomeButtonView(
              title: "Search Flights",
              subTitle: "Explore departing flights for the next two weeks"
            )
          }
          NavigationLink(
            destination: GenericView()) {
            WelcomeButtonView(
              title: "Your Awards",
              subTitle: "Earn awards for airport interactions"
            )
          }
          NavigationLink(
            destination: GenericView()) {
            WelcomeButtonView(
              title: "Saved Flights",
              subTitle: "Flights you've saved for later review"
            )
          }
          // 1
          if let id = lastFlightInfo.lastFlightId,
             let lastFlight = flightInfo.getFlightById(id)
          {
            Button(action: {
              showNextFlight = true
            }) {
              WelcomeButtonView(
                title: "Last Flight \(lastFlight.flightName)",
                subTitle: "Show Next Flight Departing or Arriving at Airport"
              )
            }
          }
          Spacer()
        }.padding()
        .font(.title)
        .foregroundColor(.white)
      }.navigationTitle("Mountain Airport")
      // End Navigation View
    }.environmentObject(lastFlightInfo)
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
  }
}
