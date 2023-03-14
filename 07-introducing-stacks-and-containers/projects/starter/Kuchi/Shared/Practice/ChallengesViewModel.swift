/// Copyright (c) 2023 Kodeco Inc.
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
import Combine

struct Challenge {
  let question: String
  let pronunciation: String
  let answer: String
  var completed: Bool = false
  var succeeded: Bool = false
}

extension Challenge: Hashable {
  func hash(into hasher: inout Hasher) {
    question.hash(into: &hasher)
  }
}

struct ChallengeTest {
  let challenge: Challenge
  let answers: [String]
  func isAnswerCorrect(_ answer: String) -> Bool {
    return challenge.answer == answer
  }
}

class ChallengesViewModel: ObservableObject {
  static let challenges: [Challenge] = [
    Challenge(question: "はい", pronunciation: "Hai", answer: "Yes"),
    Challenge(question: "いいえ", pronunciation: "iie", answer: "No"),
    Challenge(question: "おねがい　します", pronunciation: "Onegai shimasu", answer: "Please"),
    Challenge(question: "こんにちわ", pronunciation: "Konnichiwa", answer: "Hello"),
    Challenge(question: "はじめまして", pronunciation: "Hajimemashite", answer: "Nice to meet you"),
    Challenge(question: "もしもし", pronunciation: "Moshi moshi", answer: "Hello"),
    Challenge(question: "すみません", pronunciation: "Sumimasen", answer: "Excuse me"),
    Challenge(question: "ありがとう", pronunciation: "Arigatō", answer: "Thank you"),
    Challenge(question: "ごめんなさい", pronunciation: "Gomennasai", answer: "Sorry")
  ]
  
  var allAnswers: [String] { return Self.challenges.map { $0.answer }}
  var correctAnswers: [Challenge] = []
  var wrongAnswers: [Challenge] = []
  
  var numberOfAnswered: Int { return correctAnswers.count }
  @Published var currentChallenge: ChallengeTest?
  
  init() {
    generateRandomChallenge()
  }
  
  func getRandomAnswers(count: Int, including includedAnswer: String) -> [String] {
    let answers = allAnswers
    
    // If there are not enough answers, return them all
    guard count < answers.count else {
      return answers.shuffled()
    }
    
    var randomAnswers = Set<String>()
    randomAnswers.insert(includedAnswer)
    while randomAnswers.count < count {
      guard let randomAnswer = answers.randomElement() else { continue }
      randomAnswers.insert(randomAnswer)
    }
    
    return Array(randomAnswers).shuffled()
  }
  
  func generateRandomChallenge() {
    if correctAnswers.count < 5 {
      currentChallenge = getRandomChallenge()
    } else {
      currentChallenge = nil
    }
  }
  
  func restart() {
    self.correctAnswers = []
    self.wrongAnswers = []
    generateRandomChallenge()
  }
  
  private func getRandomChallenge() -> ChallengeTest? {
    return getRandomChallenges(count: 1).first
  }
  
  private func getRandomChallenges(count: Int) -> [ChallengeTest] {
    let challenges = Self.challenges.filter { $0.completed == false }
    var randomChallenges: Set<Challenge>
    
    // If there are not enough challenges, return them all
    
    if challenges.count < count {
      randomChallenges = Set(challenges)
    } else {
      randomChallenges = Set()
      while randomChallenges.count < count {
        guard let randomChallenge = challenges.randomElement() else { continue }
        randomChallenges.insert(randomChallenge)
      }
    }
    
    let tests = randomChallenges.map({
      ChallengeTest(
        challenge: $0,
        answers: getRandomAnswers(count: 3, including: $0.answer)
      )
    })
    
    return tests.shuffled()
  }
  
  func saveCorrectAnswer(for challenge: Challenge) {
    correctAnswers.append(challenge)
  }
  
  func saveWrongAnswer(for challenge: Challenge) {
    wrongAnswers.append(challenge)
  }
}
