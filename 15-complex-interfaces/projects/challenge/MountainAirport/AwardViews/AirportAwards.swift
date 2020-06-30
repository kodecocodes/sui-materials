/// Copyright (c) 2019 Razeware LLC
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

struct AirportAwards: View {
  
  var awardArray: [AwardInformation] {
    var awardList: [AwardInformation] = []
    awardList.append(AwardInformation(awardView: AnyView(FirstVisitAward()),
                                      title: "First Visit",
                                      description: "Awarded the first time you open the app while at the airport.",
                                      awarded: true))
    awardList.append(AwardInformation(awardView: AnyView(OverNightParkAward()),
                                      title: "Left Car Overnight",
                                      description: "You left you car parked overnight in one of our parking lots.",
                                      awarded: true))
    awardList.append(AwardInformation(awardView: AnyView(AirportMealAward()),
                                      title: "Meal at Airport",
                                      description: "You used the app to receive a discount at one of our restaurants.",
                                      awarded: true))
    awardList.append(AwardInformation(awardView: AnyView(FirstFlightAward()),
                                      title: "First Flight",
                                      description: "You checked in for a flight using the app for the first time.",
                                      awarded: true))
    awardList.append(AwardInformation(awardView: AnyView(HypocycloidView(R: 4.0, r: 2.0, color: Color.purple)),
                                      title: "Almost Duty Free",
                                      description: "You used the app to receive a discount at one of our vendors.",
                                      awarded: true))
    awardList.append(AwardInformation(awardView: AnyView(HypocycloidView(R: 8.0, r: 3.0, color: Color.blue)),
                                      title: "Rainy Day",
                                      description: "You flight was delayed because of weather.",
                                      awarded: true))
    awardList.append(AwardInformation(awardView: AnyView(HypocycloidView(R: 16.0, r: 5.0, color: Color.yellow)),
                                      title: "Welcome Home",
                                      description: "Your returned to the airport after leaving from it.",
                                      awarded: true))
    return awardList
  }
  
  var activeAwards: [AwardInformation] {
      awardArray.filter { $0.awarded }
  }
  
  var body: some View {
    VStack {
      Text("Your Awards (\(activeAwards.count))")
        .font(.title)
      GridView(columns: 2, items: activeAwards) { gridWidth, item in
        VStack {
          item.awardView
          Text(item.title)
        }.frame(width: gridWidth, height: gridWidth)
      }
    }
  }
}

struct AirportAwards_Previews: PreviewProvider {
  static var previews: some View {
    AirportAwards()
  }
}

