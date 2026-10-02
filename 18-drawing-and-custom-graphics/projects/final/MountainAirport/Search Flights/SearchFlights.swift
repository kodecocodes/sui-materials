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
  @State private var directionFilter: FlightDirection = .none
  @State private var city = ""
  @State private var runningSearch = false
  @State private var isSearching = false
  @State private var selectedFlight: FlightInformation?
  @State private var searchRequest: SearchRequest?
  
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
  
  struct SearchRequest: Equatable {
    let id = UUID()
    let city: String
  }
  
  var body: some View {
    VStack {
      Picker(
        selection: $directionFilter,
        label: Text("Flight Direction")
      ) {
        Text("All").tag(FlightDirection.none)
        Text("Arrivals").tag(FlightDirection.arrival)
        Text("Departures").tag(FlightDirection.departure)
      }
      .pickerStyle(.segmented)
      List {
        ForEach(flightDates, id: \.self) { date in
          Section(
            header: Text(date.formatted(.longDate)),
            footer:
              Text(
                "Matching flights \(flightsForDay(date: date).count)"
              )
              .frame(maxWidth: .infinity, alignment: .trailing)
          ) {
            ForEach(flightsForDay(date: date)) { flight in
              SearchResultRow(
                flight: flight,
                selectedFlight: $selectedFlight
              )
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      Spacer()
    }
    .overlay {
      if runningSearch {
        let city = searchRequest?.city ?? ""
        ProgressView(
          city == "" ?
          "Loading Flight List" :
            "Searching for \(city)..."
        )
        .progressViewStyle(CircularProgressViewStyle())
        .padding(AirportStyle.contentPadding * 2)
        .background(
          .regularMaterial,
          in: .rect(cornerRadius: AirportStyle.textSpacing * 2)
        )
      }
    }
    .background {
      AirportLandscape()
        .aspectRatio(1.25, contentMode: .fit)
        .frame(maxWidth: AirportStyle.readableWidth + 2 * AirportStyle.contentPadding)
        .accessibilityHidden(true)
      LinearGradient(
        colors: [Color.airportSky, Color.airportSky.opacity(0)],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
    }
    .searchable(text: $city, isPresented: $isSearching, prompt: "City Name")
    .searchSuggestions {
      ForEach(FlightData.citiesContaining(city), id: \.self) { city in
        Text(city).searchCompletion(city)
      }
    }
    .onSubmit(of: .search) {
      searchRequest = SearchRequest(city: city)
    }
    .onChange(of: isSearching) { _, isPresented in
      if !isPresented {
        searchRequest = SearchRequest(city: "")
      }
    }
    .task(id: searchRequest) {
      guard let request = searchRequest else { return }
      runningSearch = true
      defer {
        if searchRequest == request {
          runningSearch = false
        }
      }
      let results = await FlightData.searchFlightsForCity(request.city)
      guard !Task.isCancelled,
            searchRequest == request else {
        return
      }
      flightData = results
    }
    .navigationTitle("Search Flights")
    .padding()
    .fullScreenCover(item: $selectedFlight) { flight in
      FlightSearchDetails(flight: flight)
    }
  }
}

#Preview {
  NavigationStack {
    SearchFlights(
      flightData: FlightData.generateTestFlights(date: .now)
    )
    .environment(AppEnvironment())
  }
}
