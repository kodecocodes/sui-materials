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

struct SearchFlights: View {
  @State var flightData: [FlightInformation]
  @State private var date = Date()
  @State private var directionFilter: FlightDirection = .none
  @State private var city = ""
  @State private var runningSearch = false

  var matchingFlights: [FlightInformation] {
    var matchingFlights = flightData

    if directionFilter != .none {
      matchingFlights = matchingFlights.filter {
        $0.direction == directionFilter
      }
    }
    return matchingFlights
  }

  var flightDates: [Date] {
    let allDates = matchingFlights.map { $0.localTime.dateOnly }
    let uniqueDates = Array(Set(allDates))
    return uniqueDates.sorted()
  }

  func flightsForDay(date: Date) -> [FlightInformation] {
    matchingFlights.filter {
      Calendar.current.isDate($0.localTime, inSameDayAs: date)
    }
  }

  var body: some View {
    ZStack {
      Image("background-view")
        .resizable()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      VStack {
        Picker(
          selection: $directionFilter,
          label: Text("Flight Direction")) {
            Text("All").tag(FlightDirection.none)
            Text("Arrivals").tag(FlightDirection.arrival)
            Text("Departures").tag(FlightDirection.departure)
        }
        // Challenge - part 1
        // .background(Color.white)
          .foregroundColor(.white)
          .pickerStyle(SegmentedPickerStyle())
        TextField(" Search cities", text: $city)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        List {
          ForEach(flightDates, id: \.hashValue) { date in
            Section(
              header: Text(longDateFormatter.string(from: date)),
              footer:
                HStack {
                  Spacer()
                  Text("Matching flights \(flightsForDay(date: date).count)")
                }
            ) {
              ForEach(flightsForDay(date: date)) { flight in
                SearchResultRow(flight: flight)
              }
            }
          }
        }
        .overlay(
          Group {
            if runningSearch {
              VStack {
                Text("Searching...")
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle())
                  .tint(.black)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(.white)
              .opacity(0.8)
            }
          }
        )
        .listStyle(.inset)
        Spacer()
      }
      .searchable(text: $city, prompt: "City Name") {
        // 1
        ForEach(FlightData.citiesContaining(city), id: \.self) { city in
          // 2
          Text(city).searchCompletion(city)
        }
      }
      // 1
      .onSubmit(of: .search) {
        Task {
          runningSearch = true
          await flightData = FlightData.searchFlightsForCity(city)
          runningSearch = false
        }
      }
      .onChange(of: city) { newText in
        if newText.isEmpty {
          Task {
            runningSearch = true
            await flightData = FlightData.searchFlightsForCity(city)
            runningSearch = false
          }
        }
      }
      .navigationTitle("Search Flights")
      .padding()
    }
  }
}

struct SearchFlights_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SearchFlights(flightData: FlightData.generateTestFlights(date: Date())
      )
    }
  }
}
