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
  @ObservedObject var game = BullsEyeGame()
  
  @State var currentValue = 50.0
  @State var valueString = ""
  @State var showAlert = false
  
  var body: some View {
    VStack {
      Text("Guess the number:")
      TextField("1-100", text: $valueString, onEditingChanged: { _ in
        self.currentValue = Double(self.valueString) ?? 50.0
      })
        .frame(width: 150.0)
      HStack {
        Text("0")
        GeometryReader { geometry in
          ZStack {
            Rectangle()
              .frame(height: 8.0)
            Rectangle()
              .frame(width: 8.0, height: 30.0)
              .offset(x: geometry.size.width * (CGFloat(self.game.targetValue)/100.0 - 0.5), y: 0.0)
          }
        }
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
                self.valueString = ""
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
