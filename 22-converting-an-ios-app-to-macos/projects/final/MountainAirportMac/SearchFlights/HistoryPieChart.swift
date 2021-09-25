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

struct PieSegment: Identifiable {
  var id = UUID()
  var fraction: Double
  var name: String
  var color: Color
}

struct HistoryPieChart: View {
  var flightHistory: [FlightHistory]

  var onTimeCount: Int {
    flightHistory.filter { $0.timeDifference <= 0 }.count
  }

  var shortDelayCount: Int {
    flightHistory.filter {
      $0.timeDifference > 0 && $0.timeDifference <= 15
    }.count
  }

  var longDelayCount: Int {
    flightHistory.filter {
      $0.timeDifference > 15 && $0.actualTime != nil
    }.count
  }

  var canceledCount: Int {
    flightHistory.filter { $0.status == .canceled }.count
  }

  var pieElements: [PieSegment] {
    // 1
    let historyCount = Double(flightHistory.count)
    // 2
    let onTimeFrac = Double(onTimeCount) / historyCount
    let shortFrac = Double(shortDelayCount) / historyCount
    let longFrac = Double(longDelayCount) / historyCount
    let cancelFrac = Double(canceledCount) / historyCount

    // 3
    let segments = [
      PieSegment(fraction: onTimeFrac, name: "On-Time", color: Color.green),
      PieSegment(fraction: shortFrac, name: "Short Delay", color: Color.yellow),
      PieSegment(fraction: longFrac, name: "Long Delay", color: Color.red),
      PieSegment(fraction: cancelFrac, name: "Canceled", color: Color(red: 0.5, green: 0, blue: 0))
    ]

    // 4
    return segments.filter { $0.fraction > 0 }
  }

  var body: some View {
    HStack {
      GeometryReader { proxy in
        // 1
        let radius = min(proxy.size.width, proxy.size.height) / 2.0
        // 2
        let center = CGPoint(x: proxy.size.width / 2.0, y: proxy.size.height / 2.0)
        // 3
        var startAngle = 360.0
        // 4
        ForEach(pieElements) { segment in
          // 5
          let endAngle = startAngle - segment.fraction * 360.0
          // 6
          Path { pieChart in
            // 7
            pieChart.move(to: center)
            // 8
            pieChart.addArc(
              center: center,
              radius: radius,
              startAngle: .degrees(startAngle),
              endAngle: .degrees(endAngle),
              clockwise: true
            )
            // 9
            pieChart.closeSubpath()
            // 10
            startAngle = endAngle
          }
          // 11
          .foregroundColor(segment.color)
          .rotationEffect(.degrees(-90))
        }
      }
      VStack(alignment: .leading) {
        ForEach(pieElements) { segment in
          HStack {
            Rectangle()
              .frame(width: 20, height: 20)
              .foregroundColor(segment.color)
            Text(segment.name)
          }
        }
      }
    }
  }
}

struct HistoryPieChart_Previews: PreviewProvider {
  static var previews: some View {
    HistoryPieChart(
      flightHistory: FlightData.generateTestFlightHistory(
        date: Date()
      ).history
    )
  }
}
