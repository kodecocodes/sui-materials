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
import Game

struct ContentView: View {
  @ObservedObject private var game = BullsEyeGame()

  @State private var currentValue = 50.0
  @State private var showAlert = false

  private var alpha: Double {
    abs(Double(game.targetValue) - currentValue) / 100.0
  }

  var body: some View {
    VStack {
      Text("Put the Bull's Eye as close as you can to: \(game.targetValue)")
      HStack {
        Text("0")
        Slider(value: $currentValue, in: 1.0...100.0, step: 1.0)
          .background(Color.blue)
          .opacity(alpha)
        Text("100")
      }
      .padding(.horizontal)
      Button(action: {
        self.showAlert = true
        self.game.checkGuess(Int(self.currentValue))
      }) {
        Text("Hit Me!")
      }
      .alert(isPresented: $showAlert) {
        Alert(title: Text("Your Score"), message: Text(String(game.scoreRound)),
              dismissButton: .default(Text("OK"), action: {
                self.game.startNewRound()
                self.currentValue = 50.0
              }))
      }
      .padding()
      HStack {
        Text("Total Score: \(game.scoreTotal)")
        Text("Round: \(game.round)")
      }
    }
  }
}

struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

