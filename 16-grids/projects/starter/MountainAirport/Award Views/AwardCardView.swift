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

struct AwardCardView: View {
  var award: AwardInformation

  var body: some View {
    VStack {
      Image(systemName: award.symbolName)
        .font(.largeTitle)
        .shadow(radius: 10)
      Text(award.title)
        .font(.title2)
      Text(award.description)
        .font(.footnote)
      Spacer()
    }
    .padding(10.0)
    .background(
      LinearGradient(
        gradient: Gradient(
          colors: [Color.airportAirfield, Color.airportRunway]
        ),
        startPoint: .bottomLeading,
        endPoint: .topTrailing)
    )
    .saturation(award.awarded ? 1.0 : 0.0)
    .opacity(award.awarded ? 1.0 : 0.5)
    .clipShape(RoundedRectangle(cornerRadius: 25.0))
  }
}

#Preview {
  let award = AwardInformation(
    symbolName: "airplane.departure",
    title: "First Visit",
    description: "Awarded the first time you open the app while at the airport.",
    awarded: true,
    category: .travel,
    awardedDate: Date.now.dateDaysAgo(-7)!
  )
  AwardCardView(award: award)
    .frame(width: 150, height: 220)
    .padding()
    .background(Color.airportMountainNear)
}
