/// Copyright (c) 2026 Kodeco Ltd.
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
  @State private var flightInfo = FlightData()
  @State private var selectedView: FlightViewId?
  @State var appEnvironment = AppEnvironment()

  var selectedFlight: FlightInformation? {
    if let id = appEnvironment.lastFlightId {
      return flightInfo.getFlightById(id)
    }
    return nil
  }

  enum FlightViewId: CaseIterable {
    case showFlightStatus
    case searchFlights
    case showAwards
    case showTimeline
    case showLastFlight
  }

  struct ViewButton: Identifiable {
    var id: FlightViewId
    var title: String
    var subtitle: String
  }

  var sidebarButtons: [ViewButton] {
    var buttons: [ViewButton] = []

    buttons.append(
      ViewButton(
        id: .showFlightStatus,
        title: "Flight Status",
        subtitle: "Departure and arrival information"
      )
    )

    buttons.append(
      ViewButton(
        id: .searchFlights,
        title: "Search Flights",
        subtitle: "Search Upcoming Flights"
      )
    )

    buttons.append(
      ViewButton(
        id: .showAwards,
        title: "Your Awards",
        subtitle: "Earn rewards for your airport interactions"
      )
    )

    buttons.append(
      ViewButton(
        id: .showTimeline,
        title: "Flight Timeline",
        subtitle: "Flight Timeline"
      )
    )

    if let flightId = appEnvironment.lastFlightId,
      let flight = flightInfo.getFlightById(flightId)
    {
      buttons.append(
        ViewButton(
          id: .showLastFlight,
          title: "\(flight.flightName)",
          subtitle: "The Last Flight You Viewed"
        )
      )
    }

    return buttons
  }

  var body: some View {
    NavigationSplitView {
      Group {
        VStack(spacing: AirportStyle.sectionSpacing) {
          if !appEnvironment.savedFlightIds.isEmpty {
            TimelineView(.everyMinute) { context in
              Text("Saved Flights")
              ForEach(appEnvironment.savedFlightIds, id: \.self) { flightId in
                if let flight = flightInfo.getFlightById(flightId) {
                  FlightCardView(
                    flight: flight,
                    date: context.date,
                    showMap: false
                  )
                  .padding()
                }
              }
            }
          }
          List(sidebarButtons) { button in
            Button {
              selectedView = button.id
            } label: {
              WelcomeViewButton(
                title: button.title,
                subtitle: button.subtitle,
                isSelected: selectedView == button.id
              )
            }
            .buttonStyle(.plain)
          }
          .scrollContentBackground(.hidden)
          .navigationTitle("Mountain Airport")
        }
        .padding(.vertical, AirportStyle.sectionSpacing)
        .frame(minWidth: 240, maxWidth: .infinity, alignment: .center)
      }
      .background {
        AirportLandscape()
          .aspectRatio(1.25, contentMode: .fit)
          .frame(
            maxWidth: AirportStyle.readableWidth + 2
              * AirportStyle.contentPadding
          )
          .accessibilityHidden(true)
        LinearGradient(
          colors: [Color.airportSky, Color.airportSky.opacity(0)],
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()
      }
    } detail: {
      if let view = selectedView {
        switch view {
        case .showFlightStatus:
          FlightStatusBoard(
            flights: flightInfo.getDaysFlights(.now)
          )
        case .searchFlights:
          SearchFlights(flightData: flightInfo.flights)
        case .showAwards:
          AwardsView()
        case .showTimeline:
          FlightTimelineView(
            flights: flightInfo.getDaysFlights(.now)
          )
        case .showLastFlight:
          if let flightId = appEnvironment.lastFlightId,
            let flight = flightInfo.getFlightById(flightId)
          {
            FlightStatusBoard(
              flights: flightInfo.getDaysFlights(Date()),
              flightToShow: flight
            )
          }
        }
      } else {
        Text("Select an option in the sidebar.")
      }
    }
    .environment(appEnvironment)
  }
}

#Preview {
  WelcomeView()
}
