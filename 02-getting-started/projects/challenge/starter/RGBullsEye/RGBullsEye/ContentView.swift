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

  var body: some View {
    VStack {
      Circle()
        .fill(Color(rgbStruct: game.target))
      if !showScore {
        Text("R: ??? G: ??? B: ???")
          .padding()
      } else {
        Text(game.target.intString())
          .padding()
      }
      Circle()
        .fill(Color(rgbStruct: guess))
      Text(guess.intString())
        .padding()
      ColorSlider(value: $guess.red, trackColor: .red)
      ColorSlider(value: $guess.green, trackColor: .green)
      ColorSlider(value: $guess.blue, trackColor: .blue)
      Button("Hit Me!") {
        showScore = true
        game.check(guess: guess)
      }
      .alert(isPresented: $showScore) {
        Alert(
          title: Text("Your Score"),
          message: Text(String(game.scoreRound)),
          dismissButton: .default(Text("OK")) {
            game.startNewRound()
            guess = RGB()
          })
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(guess: RGB())
  }
}

struct ColorSlider: View {
  @Binding var value: Double
  var trackColor: Color

  var body: some View {
    HStack {
      Text("0")
      Slider(value: $value)
        .accentColor(trackColor)
      Text("255")
    }
    .padding(.horizontal)
  }
}
