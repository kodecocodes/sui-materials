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

struct AwardDetails: View {
  var award: AwardInformation
  @Environment(\.dismiss) var dismiss

  func imageSize(proxy: GeometryProxy) -> Double {
    let size = min(proxy.size.width, proxy.size.height)
    return size * 0.8
  }

  var body: some View {
    VStack(alignment: .center) {
      HStack {
        Spacer()
        Button(action: {
          dismiss()
        }, label: {
          Image(systemName: "xmark.circle")
            .font(.largeTitle)
        }).buttonStyle(.plain)
      }

      Image(award.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding()
      Text(award.title)
        .font(.title)
        .padding()
      Text(award.description)
        .font(.body)
        .padding()
      Spacer()
    }.padding()
      .opacity(award.awarded ? 1.0 : 0.4)
      .saturation(award.awarded ? 1 : 0)
  }
}

struct AwardDetails_Previews: PreviewProvider {
  static var previews: some View {
    let award = AwardInformation(
      imageName: "first-visit-award",
      title: "First Visit",
      description: "Awarded the first time you open the app while at the airport.",
      awarded: true
    )

    let award2 = AwardInformation(
      imageName: "rainy-day-award",
      title: "Rainy Day",
      description: "Your flight was delayed because of weather.",
      awarded: false
    )

    Group {
      AwardDetails(award: award)
      AwardDetails(award: award2)
    }
  }
}
