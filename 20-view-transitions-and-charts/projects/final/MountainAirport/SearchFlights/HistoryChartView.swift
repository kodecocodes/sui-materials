/// Copyright (c) 2023 Kodeco Inc
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

func barGradientColors(_ history: FlightHistory) -> Gradient {
  if history.status == .canceled {
    return Gradient(
      colors: [
        Color.green,
        Color.yellow,
        Color.red,
        Color(red: 0.5, green: 0, blue: 0)
      ] )
  }
  if history.timeDifference <= 0 {
    return Gradient(colors: [Color.green])
  }
  if history.timeDifference <= 15 {
    return Gradient(colors: [Color.green, Color.yellow])
  }
  return Gradient(
    colors: [Color.green, Color.yellow, Color.red]
  )
}

struct HistoryChartView: View {
  var flightHistory: [FlightHistory]

  var body: some View {
    // 1
    Chart {
      // 2
      ForEach(flightHistory, id: \.self) { history in
        // 3
        BarMark(
          // 4
          x: .value("Minutes", history.timeDifference),
          y: .value("Days Ago", "\(history.day) day(s) ago")
        )
        .foregroundStyle(
          // 1
          LinearGradient(
            gradient: barGradientColors(history),
            // 2
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .annotation(position: .overlay) {
          Text(history.flightDelayDescription)
            .font(.caption)
        }
      }
    }
    // 1
    .chartXAxis {
      // 2
      AxisMarks(values: [-10, 0, 10, 20, 30, 40, 50, 60]) { value in
        // 3
        AxisGridLine(
          centered: true,
          stroke: StrokeStyle(lineWidth: 1.0, dash: [5.0, 5.0])
        )
        .foregroundStyle(.white.opacity(0.8))
        AxisValueLabel() {
          // 1
          if let value = value.as(Int.self) {
            // 2
            Text(value, format: .number)
              .foregroundColor(Color.white.opacity(0.8))
          }
        }
      }
    }
    .chartYAxis {
      // 1
      AxisMarks(values: .automatic) { value in
        AxisGridLine(centered: false, stroke: StrokeStyle(lineWidth: 1.0))
          .foregroundStyle(Color.white.opacity(0.8))
        AxisValueLabel() {
          // 2
          if let value = value.as(String.self) {
            Text(value)
              .font(.footnote)
              .foregroundColor(Color.white.opacity(0.8))
          }
        }
      }
    }
    .chartYAxisLabel {
      Text("Delay in Minutes")
        .foregroundColor(.white)
        .font(.callout)
    }
    .chartXScale(domain: -18...63)
  }
}

struct HistoryChartView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryChartView(
      flightHistory: FlightData.generateTestFlight(date: Date()).history
    )
  }
}
