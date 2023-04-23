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

import Foundation

struct TerminalStore: Identifiable {
  var id: Int
  var terminal: String
  var name: String
  var shortName: String
  var howBusy: Double {
    let minute = Calendar.current.dateComponents([.minute], from: Date()).minute ?? 0
    let adjustedMinute = (minute + id * 10) % 60
    let fraction = Double(adjustedMinute) / 60.0

    return fraction
  }

  static var allStores: [TerminalStore] {
    var stores: [TerminalStore] = []

    stores.append(TerminalStore(id: 1, terminal: "A", name: "Juniper Fiddler", shortName: "Juniper"))
    stores.append(TerminalStore(id: 2, terminal: "A", name: "Orange Emperor", shortName: "Orange"))
    stores.append(TerminalStore(id: 3, terminal: "A", name: "Aqua Sunset", shortName: "Aqua"))

    stores.append(TerminalStore(id: 4, terminal: "B", name: "The Olive Morning", shortName: "Olive"))
    stores.append(TerminalStore(id: 5, terminal: "B", name: "The Ruby Afternoon", shortName: "Ruby"))
    stores.append(TerminalStore(id: 6, terminal: "B", name: "Sunset Elements", shortName: "Sunset"))

    return stores
  }

  static var terminalStoresA: [TerminalStore] {
    return allStores.filter { $0.terminal == "A" }
  }

  static var terminalStoresB: [TerminalStore] {
    return allStores.filter { $0.terminal == "B" }
  }
}
