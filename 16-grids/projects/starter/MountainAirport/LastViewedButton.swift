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

struct LastViewedButton: View {
  @ObservedObject var flightInfo: FlightData
  @ObservedObject var appEnvironment: AppEnvironment
  @Binding var showNextFlight: Bool

  var body: some View {
    if
      let id = appEnvironment.lastFlightId,
      let lastFlight = flightInfo.getFlightById(id) {
      // swiftlint:disable multiple_closures_with_trailing_closure
      Button(action: {
        showNextFlight = true
      }) {
        WelcomeButtonView(
          title: "Last Viewed Flight",
          subTitle: lastFlight.flightName,
          imageName: "suit.heart.fill"
        )
      }
      // swiftlint:enable multiple_closures_with_trailing_closure
    } else {
      Spacer()
    }
  }
}

struct LastViewedButton_Previews: PreviewProvider {
  static var previews: some View {
    let environment = AppEnvironment()
    environment.lastFlightId = 1
    return LastViewedButton(flightInfo: FlightData(), appEnvironment: environment, showNextFlight: .constant(false))
  }
}
