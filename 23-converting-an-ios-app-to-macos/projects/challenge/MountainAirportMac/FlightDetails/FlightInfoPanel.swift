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

extension AnyTransition {
  static var buttonNameTransition: AnyTransition {
    let insertion = AnyTransition.move(edge: .trailing)
      .combined(with: .opacity)
    let removal = AnyTransition.scale(scale: 0.0)
      .combined(with: .opacity)
    return .asymmetric(insertion: insertion, removal: removal)
  }
}

struct FlightInfoPanel: View {
  var flight: FlightInformation
  @State private var showTerminal = false

  var timeFormatter: DateFormatter {
    let tdf = DateFormatter()
    tdf.timeStyle = .short
    tdf.dateStyle = .none
    return tdf
  }

  var body: some View {
    HStack(alignment: .top) {
      Image(systemName: "info.circle")
        .resizable()
        .frame(width: 35, height: 35, alignment: .leading)
      VStack(alignment: .leading) {
        Text("Flight Details")
          .font(.title2)
        if flight.direction == .arrival {
          Text("Arriving at Gate \(flight.gate)")
          Text("Flying from \(flight.otherAirport)")
        } else {
          Text("Departing from Gate \(flight.gate)")
          Text("Flying to \(flight.otherAirport)")
        }
        Text(flight.flightStatus) + Text(" (\(timeFormatter.string(from: flight.localTime)))")
        Button(action: {
          withAnimation {
            showTerminal.toggle()
          }
        }, label: {
          HStack(alignment: .center) {
            Image(systemName: "airplane.circle")
              .resizable()
              .frame(width: 30, height: 30)
              .padding(.trailing, 10)
              .rotationEffect(.degrees(showTerminal ? 90 : 270))
              .animation(
                .spring(
                  response: 0.55,
                  dampingFraction: 0.45,
                  blendDuration: 0
                ),
                value: showTerminal
              )
            Spacer()
            Group {
              if showTerminal {
                Text("Hide Terminal Map")
              } else {
                Text("Show Terminal Map")
              }
            }
            .transition(.buttonNameTransition)
            Spacer()
            Image(systemName: "airplane.circle")
              .resizable()
              .frame(width: 30, height: 30)
              .padding(.trailing, 10)
              .rotationEffect(.degrees(showTerminal ? 90 : 270))
              .animation(
                .spring(
                  response: 0.55,
                  dampingFraction: 0.45,
                  blendDuration: 0
                ),
                value: showTerminal
              )
          }
        }).buttonStyle(.plain)

        if showTerminal {
          FlightTerminalMap(flight: flight)
        }
        Spacer()
      }
    }
  }
}

struct FlightInfoPanel_Previews: PreviewProvider {
  static var previews: some View {
    FlightInfoPanel(
      flight: FlightData.generateTestFlight(date: Date())
    )
  }
}
