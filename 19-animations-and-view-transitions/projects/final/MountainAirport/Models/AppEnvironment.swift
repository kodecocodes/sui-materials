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

class AppEnvironment: ObservableObject {
  @Published var lastFlightId: Int?
  @Published var awardList: [AwardInformation] = []

  init() {
    awardList.append(
      AwardInformation(
        imageName: "first-visit-award",
        title: "First Visit",
        description: "Awarded the first time you open the app while at the airport.",
        awarded: true,
        stars: 1
      )
    )
    awardList.append(
      AwardInformation(
        imageName: "overnight-award",
        title: "Left Car Overnight",
        description: "You left you car parked overnight in one of our parking lots.",
        awarded: true,
        stars: 2
      )
    )
    awardList.append(
      AwardInformation(
        imageName: "meal-award",
        title: "Meal at Airport",
        description: "You used the app to receive a discount at one of our restaurants.",
        awarded: false,
        stars: 2
      )
    )
    awardList.append(
      AwardInformation(
        imageName: "first-flight-award",
        title: "First Flight",
        description: "You checked in for a flight using the app for the first time.",
        awarded: true,
        stars: 3
      )
    )
    awardList.append(
      AwardInformation(
        imageName: "shopping-award",
        title: "Almost Duty Free",
        description: "You used the app to receive a discount at one of our vendors.",
        awarded: true,
        stars: 2
      )
    )
    awardList.append(
      AwardInformation(
        imageName: "rainy-day-award",
        title: "Rainy Day",
        description: "You flight was delayed because of weather.",
        awarded: false,
        stars: 3
      )
    )
    awardList.append(
      AwardInformation(
        imageName: "return-home-award",
        title: "Welcome Home",
        description: "Your returned to the airport after leaving from it.",
        awarded: true,
        stars: 2
      )
    )
  }
}
