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
import Charts

enum DelayCategory: String, Plottable {
  case onTime = "On Time"
  case shortDelay = "Short Delay"
  case longDelay = "Long Delay"
  case canceled = "Canceled"
}

extension FlightHistory {
  var delayCategory: DelayCategory {
    if status == .canceled { return .canceled }
    if timeDifference <= 0 { return .onTime }
    if timeDifference <= 15 { return .shortDelay }
    return .longDelay
  }
}

struct HistoryChartView: View {
  var flightHistory: [FlightHistory]
  
  func delayAnnotationLocation(_ category: DelayCategory) -> AnnotationPosition {
    if category == .canceled || category == .longDelay {
      return .overlay
    }
    return .trailing
  }
  
  var body: some View {
    // 1
    Chart {
      // 2
      ForEach(flightHistory) { history in
        // 3
        BarMark(
          // 4
          x: .value("Minutes", history.timeDifference),
          y: .value("Days Ago", "\(history.day) day(s) ago")
        )
        .foregroundStyle(by: .value("Delay", history.delayCategory))
        .annotation(
          position: delayAnnotationLocation(history.delayCategory)
        ) {
          Text(history.flightDelayDescription)
            .font(.caption)
        }
      }
    }
    .chartForegroundStyleScale([
      DelayCategory.onTime: Color.green,
      DelayCategory.shortDelay: Color.yellow,
      DelayCategory.longDelay: Color.red,
      DelayCategory.canceled: Color.gray
    ])
    // 1
    .chartXAxis {
      // 2
      AxisMarks(values: [-10, 0, 10, 20, 30, 40, 50, 60]) { value in
        // 3
        AxisGridLine(
          centered: true,
          stroke: StrokeStyle(lineWidth: 1.0, dash: [5.0, 5.0])
        )
        // 4
        AxisValueLabel()
      }
    }
    .chartXScale(domain: -18...63)
  }
}

#Preview {
  HistoryChartView(
    flightHistory: FlightData.generateTestFlight(
      date: .now
    ).history
  )
}
