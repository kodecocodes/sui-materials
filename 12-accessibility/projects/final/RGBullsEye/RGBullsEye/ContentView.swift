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

struct ContentView: View {
  @State var game = Game()
  @State var guess: RGB
  @State var showScore = false

  let circleSize: CGFloat = 0.275
  let labelHeight: CGFloat = 0.06
  let labelWidth: CGFloat = 0.53
  let buttonWidth: CGFloat = 0.87

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Color.element
          .edgesIgnoringSafeArea(.all)
        VStack {
          ColorCircle(
            rgb: game.target,
            size: proxy.size.height * circleSize)
          if !showScore {
            BevelText(
              text: "R: ??? G: ??? B: ???",
              width: proxy.size.width * labelWidth,
              height: proxy.size.height * labelHeight)
              .accessibilityLabel("Target red, green, blue, values you must guess")
          } else {
            BevelText(
              text: game.target.intString,
              width: proxy.size.width * labelWidth,
              height: proxy.size.height * labelHeight)
          }
          ColorCircle(
            rgb: guess,
            size: proxy.size.height * circleSize)
          BevelText(
            text: guess.intString,
            width: proxy.size.width * labelWidth,
            height: proxy.size.height * labelHeight)
            .accessibilityLabel("Your guess: " + guess.accString)
            .accessibilitySortPriority(2)
            ColorSlider(value: $guess.red, trackColor: .red)
              .accessibilitySortPriority(5)
            ColorSlider(value: $guess.green, trackColor: .green)
              .accessibilitySortPriority(4)
            ColorSlider(value: $guess.blue, trackColor: .blue)
              .accessibilitySortPriority(3)
          Button("Hit Me!") {
            self.showScore = true
            self.game.check(guess: guess)
          }
          .accessibilitySortPriority(1)
          .buttonStyle(
            NeuButtonStyle(
              width: proxy.size.width * buttonWidth,
              height: proxy.size.height * labelHeight))
          .sheet(isPresented: $showScore) {
            SuccessView(
              game: $game,
              score: game.scoreRound,
              target: game.target,
              guess: $guess)
          }
        }
        .font(.headline)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView(guess: RGB())
        .previewDevice("iPhone 8")
      ContentView(guess: RGB())
      ContentView(guess: RGB())
        .previewDevice("iPhone 12 Pro Max")
    }
  }
}

struct ColorSlider: View {
  @Binding var value: Double
  var trackColor: Color
  var body: some View {
    HStack {
      Text("0")
        .accessibilityHidden(true)
      Slider(value: $value)
        .accentColor(trackColor)
        .accessibilityValue(
            String(describing: trackColor) +
            String(Int(value * 255)))
      Text("255")
        .accessibilityHidden(true)
    }
    .font(.subheadline)
    .padding(.horizontal)
  }
}
