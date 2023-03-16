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

struct TerminalStoresView: View {
  var flight: FlightInformation
  @State private var showStores = false

  var stores: [TerminalStore] {
    if flight.terminal == "A" {
      return TerminalStore.terminalStoresA
    } else {
      return TerminalStore.terminalStoresB
    }
  }

  func storeAnimation(_ storeNumber: Int) -> Animation {
    return .easeInOut.delay(Double(storeNumber) * 0.3)
  }

  var body: some View {
    GeometryReader { proxy in
      let width = proxy.size.width
      let height = proxy.size.height
      let storeWidth = width / 6
      let storeHeight = storeWidth / 1.75
      let storeSpacing = width / 5
      let firstStoreOffset = flight.terminal == "A" ?
      width - storeSpacing :
      storeSpacing - storeWidth
      let direction = flight.terminal == "A" ? -1.0 : 1.0
      ForEach(stores.indices, id: \.self) { index in
        let store = stores[index]
        let xOffset = Double(index) * storeSpacing * direction + firstStoreOffset
        RoundedRectangle(cornerRadius: 5.0)
          .foregroundColor(
            Color(
              hue: 0.3333,
              saturation: 1.0 - store.howBusy,
              brightness: 1.0 - store.howBusy
            )
          )
          .overlay(
            Text(store.shortName)
              .font(.footnote)
              .foregroundColor(.white)
              .shadow(radius: 5)
          )
          .frame(width: storeWidth, height: storeHeight)
          .offset(
            x: showStores ?
              xOffset :
              firstStoreOffset - direction * width,
            y: height * 0.4
          )
          .animation(storeAnimation(index), value: showStores)
      }
    }
    .onAppear {
      showStores = true
    }
  }
}

struct TerminalStoresView_Previews: PreviewProvider {
  static var previews: some View {
    TerminalStoresView(flight: FlightData.generateTestFlight(date: Date()))
  }
}
