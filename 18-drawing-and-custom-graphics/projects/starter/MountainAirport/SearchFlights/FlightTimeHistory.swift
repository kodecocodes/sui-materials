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

struct FlightTimeHistory: View {
  var flight: FlightInformation

  var timeFormatter: RelativeDateTimeFormatter {
    let rtf = RelativeDateTimeFormatter()
    rtf.unitsStyle = .full
    rtf.dateTimeStyle = .named
    return rtf
  }

  func relativeDate(_ date: Date) -> String {
    return timeFormatter.localizedString(for: date, relativeTo: Date())
  }

  var body: some View {
    ZStack {
      Image("background-view")
        .resizable()
        .aspectRatio(contentMode: .fill)
      VStack {
        Text("On Time History for \(flight.statusBoardName)")
          .font(.title2)
          .padding(.top, 30)
        ScrollView {
          ForEach(flight.history, id: \.day) { history in
            HStack {
              Text("\(history.day) day(s) ago - \(history.flightDelayDescription)")
                .padding()
              Spacer()
            }
            .background(
              Color.white.opacity(0.2)
            )
          }
        }
      }
    }.foregroundColor(.white)
  }
}

struct FlightTimeHistory_Previews: PreviewProvider {
  static var previews: some View {
    FlightTimeHistory(
      flight: FlightData.generateTestFlight(date: Date())
    )
  }
}
