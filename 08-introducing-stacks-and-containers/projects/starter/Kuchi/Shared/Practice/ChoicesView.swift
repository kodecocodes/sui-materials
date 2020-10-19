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

/// Displays the view for the choices available for the practice
/// question.
struct ChoicesView : View {
  let challengeTest: ChallengeTest
  @State var challengeSolved = false
  @State var isChallengeResultAlertDisplayed = false
  @ObservedObject var challengesViewModel = ChallengesViewModel()
  
  var body: some View {
    VStack(spacing: 25) {
      ForEach(0 ..< challengeTest.answers.count) { index in
        Button(action: {
          self.challengeSolved = self.checkAnswer(at: index)
          self.isChallengeResultAlertDisplayed = true
        }, label: {
          ChoicesRow(choice: self.challengeTest.answers[index])
        }).alert(isPresented: self.$isChallengeResultAlertDisplayed, content: {
          self.challengeOutcomeAlert()
        })
        Divider()
      }
    }
  }
  
  func challengeOutcomeAlert() -> Alert {
    let alert: Alert
    
    if challengeSolved {
      let dismissButton = Alert.Button.default(Text("OK")) {
        self.isChallengeResultAlertDisplayed = false
        self.challengesViewModel.generateRandomChallenge()
      }
      
      alert = Alert(
        title: Text("Congratulations"),
        message: Text("The answer is correct"),
        dismissButton: dismissButton
      )
    } else {
      let dismissButton = Alert.Button.default(Text("OK")) {
        self.isChallengeResultAlertDisplayed = false
      }
      
      alert = Alert(
        title: Text("Oh no!"),
        message: Text("Your answer is not correct!"),
        dismissButton: dismissButton
      )
    }
    
    return alert
  }
  
  func checkAnswer(at index: Int) -> Bool {
    let answer = self.challengeTest.answers[index]
    let challengeSolved: Bool
    
    if challengeTest.isAnswerCorrect(answer) {
      challengeSolved = true
      challengesViewModel.saveCorrectAnswer(for: self.challengeTest.challenge)
    } else {
      challengeSolved = false
      challengesViewModel.saveWrongAnswer(for: self.challengeTest.challenge)
    }
    
    isChallengeResultAlertDisplayed = true
    return challengeSolved
  }
}

struct ChoicesView_Previews : PreviewProvider {
  static let challengesViewModel = ChallengesViewModel()
  
  static var previews: some View {
    challengesViewModel.generateRandomChallenge()
    return ChoicesView(challengeTest: challengesViewModel.currentChallenge!)
  }
}
