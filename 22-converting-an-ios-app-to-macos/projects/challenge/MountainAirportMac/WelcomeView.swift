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

struct WelcomeView: View {
  var flightInfo: FlightData

  @State var showNextFlight = false
  @StateObject var appEnvironment = AppEnvironment()

  @SceneStorage("displayState") var displayState: DisplayState = .none
  @SceneStorage("lastViewedFlightID") var lastViewedFlightID: Int?

  var lastViewedFlight: FlightInformation? {
    if let id = lastViewedFlightID {
      return flightInfo.getFlightById(id)
    }
    return nil
  }

  var body: some View {
    VStack {
      WelcomeAnimation()
        .foregroundColor(.white)
        .frame(height: 40)
        .padding()
      Button(action: { displayState = .flightBoard }, label: {
        FlightStatusButton()
      }).buttonStyle(.plain)

      Button(action: { displayState = .searchFlights }, label: {
        SearchFlightsButton()
      }).buttonStyle(.plain)

      Button(action: { displayState = .awards }, label: {
        AwardsButton()
      }).buttonStyle(.plain)

      Button(action: { displayState = .timeline }, label: {
        TimelineButton()
      }).buttonStyle(.plain)

      if let lastFlight = lastViewedFlight {
        Button(action: {
          displayState = .lastFlight
          showNextFlight = true
        }, label: {
          LastViewedButton(name: lastFlight.flightName)
        }).buttonStyle(.plain)
      }
      Spacer()
    }
    .padding()
    .frame(
      minWidth: 190,
      idealWidth: 190,
      maxWidth: 190,
      minHeight: 800,
      idealHeight: 800,
      maxHeight: .infinity
    )
    .background(
      Image("welcome-background")
        .resizable()
        .aspectRatio(contentMode: .fill)
    )
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView(flightInfo: FlightData())
      .previewLayout(.fixed(width: 190, height: 800))
  }
}
