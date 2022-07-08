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
    
  var body: some View {
      VStack {
          Color(rgbStruct: game.target)
          Text("R: ??? G: ??? B: ???")
              .padding()
          Color(rgbStruct: guess)
          Text(
            // here we only need the read values as you won't be changing them in the test view
            "R: \(Int(guess.red*255.0))"
            + " G: \(Int(guess.green*255.0))"
            + " B: \(Int(guess.blue*255.0))")
              .padding()
          HStack {
              Text("0")
              // the "$" before guess.red changes guess.red from a read-only value to a read-write binding
              Slider(value: $guess.red)
                  .accentColor(.red)
              Text("255")
          }
          .padding(.horizontal)
          Button(action: {}){
              Text("Hit Me!")
          }
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView(guess: RGB(red: 0.8 , green: 0.3, blue: 0.7))
  }
}
