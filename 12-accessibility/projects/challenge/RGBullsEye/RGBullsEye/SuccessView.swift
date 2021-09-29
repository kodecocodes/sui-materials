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

struct SuccessView: View {
  @ScaledMetric var imageSize: CGFloat = 80
  @Environment(\.presentationMode) var presentationMode
  @Binding var game: Game
  let score: Int
  let target: RGB
  @Binding var guess: RGB

  var body: some View {
    ZStack {
      VStack {
        Image("wand")
          .resizable()
          .accessibilityHidden(true)
          .frame(width: imageSize, height: imageSize)
        Text("Congratulations!")
          .font(.largeTitle)
          .fontWeight(.semibold)
          .padding(.bottom)
        VStack(spacing: 10) {
          Text("You scored \(score) points on this color.")
            .padding(.bottom)
          ColorText(
            text: "Target: " + target.intString,
            bkgd: Color(rgbStruct: target))
            .accessibilityLabel(Text("Target: " + target.accString))
          ColorText(
            text: "Guess: " + guess.intString,
            bkgd: Color(rgbStruct: guess))
            .accessibilityLabel(Text("Your guess: " + guess.accString))
        }
        .font(.title3)
        .foregroundColor(Color("grayText"))
        .multilineTextAlignment(.center)
      }
      .accessibilityElement(children: .combine)
      VStack(spacing: 20) {
        Spacer()
        Button("Try another one?") {
          game.startNewRound()
          guess = RGB()
          presentationMode.wrappedValue.dismiss()
        }
          .buttonStyle(
            NeuButtonStyle(width: 327, height: 48)
        )
      }
    }
  }
}

struct ColorText: View {
  let text: String
  let bkgd: Color

  var body: some View {
    Text(text)
      .padding(10)
      .background(Capsule().fill(bkgd))
      .foregroundColor(bkgd.accessibleFontColor)
      .font(.footnote)
  }
}

struct SuccessView_Previews: PreviewProvider {
  static var previews: some View {
    SuccessView(
      game: .constant(Game()),
      score: 95,
      target: RGB(),
      guess: .constant(RGB()))
      
  }
}
