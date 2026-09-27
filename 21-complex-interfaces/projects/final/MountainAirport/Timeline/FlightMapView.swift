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
import MapKit

struct FlightMapView: View {
  var startCoordinate: CLLocationCoordinate2D
  var endCoordinate: CLLocationCoordinate2D
  var progress: Double

  var circleSize: Double {
    let loc1 = CLLocation(
      latitude: startCoordinate.latitude, longitude: startCoordinate.longitude
    )
    let loc2 = CLLocation(
      latitude: endCoordinate.latitude, longitude: endCoordinate.longitude
    )
    
    let distance = loc2.distance(from: loc1)
    
    return distance * 0.015
  }
  
  var flownPath: MKPolyline {
    // 1
    let route = MKGeodesicPolyline(
      coordinates: [
        startCoordinate,
        endCoordinate
      ],
      count: 2
    )
    // 2
    let count = max(1, Int(Double(route.pointCount - 1) * progress) + 1)
    // 3
    return MKPolyline(points: route.points(), count: count)
  }

  var body: some View {
    // 1
    Map(initialPosition: .automatic, interactionModes: []) {
      // 2
      MapPolyline(coordinates: [startCoordinate, endCoordinate], contourStyle: .geodesic)
        // 3
        .stroke(.blue.opacity(0.3), lineWidth: 3)
      MapPolyline(flownPath)
        .stroke(.blue, lineWidth: 3)
      MapCircle(center: startCoordinate, radius: circleSize)
      MapCircle(center: endCoordinate, radius: circleSize)
    }
    // 4
    .mapStyle(.standard(emphasis: .muted))
  }
}

#Preview {
  FlightMapView(
    startCoordinate:
      CLLocationCoordinate2D(
        latitude: 35.655, longitude: -83.4411
      ),
    endCoordinate:
      CLLocationCoordinate2D(
        latitude: 36.0840, longitude: -115.1537
      ),
    progress: 0.67
  )
  .frame(width: 300, height: 300)
}
