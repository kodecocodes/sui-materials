/// Copyright (c) 2019 Razeware LLC
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
import Combine

import Assessing
import Languages
import Learning

final internal class PracticeStore {
  
  // MARK: - Constants
  
  let willChange = PassthroughSubject<Void, Never>()
  
  // MARK: - Variables
  
  var answers: [String] { cards.map { $0.word.translation } }
  
  var assessment: WordAssessment? {
    index < assessments.count ? assessments[index] : nil
  }
  
  var assessments = [WordAssessment]() {
    willSet {
      willChange.send()
    }
  }
  
  var cards = [WordCard]() /* {
   willSet {
   willChange.send()
   }
   }*/
  
  var index: Int = 0
  
  var score: Int {
    return self.assessments.filter {
      $0.card.succeeded
    }.count
  }
  
  var started: Bool {
    assessments.count > 0
  }
  
  var finished: Bool {
    assessments.count > 0 && assessments.count == score
  }
  
  var submissions = [String]() {
    willSet {
      willChange.send()
    }
  }
  
  func isSubmissionCorrect(at index: Int) -> Bool {
    assessments[index].isAnswerCorrect(submissions[index])
  }
  
  // MARK: - Constructors
  
  init() {
    
  }
  
  // MARK: - Public Methods
  
  func assess() -> WordAssessment? {
    return assessments[score]
  }
  
  func build() {
    cards = DeckBuilder.default.build()
    assessments = DeckBuilder.default.assess(upTo: 500)
    submissions = [String](repeating: "", count: assessments.count)
  }
  
  func answer(with answer: String) -> Bool {
    submissions[index] = answer
    
    if assessments[index].card.word.translation == answer {
      assessments[index].card.succeeded = true
      index += 1
      
      return true
    }
    
    return false
  }
  
  func saveCorrectAnswer(for card: WordCard) {
    
  }
  
  func saveWrongAnswer(for card: WordCard) {
    
  }
}
