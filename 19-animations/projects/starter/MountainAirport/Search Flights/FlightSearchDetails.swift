/// Copyright (c) 2026 Kodeco inc
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

struct FlightSearchDetails: View {
  var flight: FlightInformation
  @Environment(AppEnvironment.self) private var appEnvironment
  @Environment(\.dismiss) private var dismiss
  @State private var rebookAlert = false
  @State private var phone = ""
  @State private var pin = ""
  @State private var checkInFlight: CheckInInfo?
  @State private var showFlightHistory = false
  
  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        FlightDetailHeader(flight: flight)
        Button("On-Time History") {
          showFlightHistory.toggle()
        }
        .popover(
          isPresented: $showFlightHistory,
          arrowEdge: .top
        ) {
          FlightTimeHistory(flight: flight)
            .padding()
            .presentationCompactAdaptation(.popover)
        }
        if flight.status == .canceled {
          Button("Rebook Flight") {
            rebookAlert = true
          }
          .alert("Contact Your Airline", isPresented: $rebookAlert) {
            TextField("Phone", text: $phone)
            SecureField("PIN", text: $pin)
            Button("Call Me") {
            }
            Button("Cancel", role: .cancel) {
            }
          } message: {
            let messageText = """
            We cannot rebook this flight. Please enter your phone \
            number and a PIN you will provide to confirm your \
            identity.
            """
            Text(messageText)
          }
        }
        if flight.isCheckInAvailable {
          Button("Check In for Flight") {
            checkInFlight =
            CheckInInfo(
              airline: flight.airline,
              flight: flight.number
            )
          }
          .confirmationDialog("Check In", item: $checkInFlight) { checkIn in
            Button("Cancel", role: .cancel) {
              print("Canceled")
            }
            Button("Reschedule Flight", role: .destructive) {
              print("Reschedule Flight")
            }
            Button("Check In", role: .confirm) {
              print("Check In flight: \(checkIn.flight)")
            }
          } message: { checkIn in
            Text("Check in for \(checkIn.airline) Flight \(checkIn.flight)")
          }
        }
        FlightInfoPanel(flight: flight)
          .padding()
        Spacer()
      }
      .padding()
      .background(
        AirportLandscape()
          .aspectRatio(contentMode: .fit)
          .opacity(0.4),
        alignment: .bottom
      )
      .onAppear {
        appEnvironment.lastFlightId = flight.id
      }
      .toolbar {
        Button(role: .close) {
          dismiss()
        }
      }
      .interactiveDismissDisabled()
    }
  }
}

#Preview {
  FlightSearchDetails(
    flight: FlightData.generateTestFlight(date: Date())
  )
  .environment(AppEnvironment())
}
