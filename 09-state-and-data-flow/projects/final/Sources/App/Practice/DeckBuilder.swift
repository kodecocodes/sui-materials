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

import Foundation

import Assessing
import Learning

final class DeckBuilder {
  
  // MARK: - Static variables
  
  static var `default` = DeckBuilder()
  
  // MARK: - Variables
  
  var answers: [String] { return cards.map { $0.word.translation }}
  
  var cards = [WordCard]()
  
  // MARK: - Initializers
  
  private init() { }
  
  // MARK: - Methods
  
  func build() -> [WordCard] {
    self.cards = [WordCard]()
    
    if let words = LanguageLoader.loadTranslatedWords(from: "jp") {
      words.forEach { word in
        cards.append(WordCard(from: word))
      }
    }
    
    return self.cards
  }
  
  func assess(upTo count: Int) -> [WordAssessment] {
    let cards = self.cards.filter { $0.completed == false }
    var randomCards: Set<WordCard>
    
    // If there are not enough cards, return them all
    
    if cards.count < count {
      randomCards = Set(cards)
    } else {
      randomCards = Set()
      while randomCards.count < count {
        guard let randomCard = cards.randomElement() else { continue }
        randomCards.insert(randomCard)
      }
    }
    
    let tests = randomCards.map({
      WordAssessment(
        card: $0,
        answers: getRandomAnswers(count: 3, including: $0.word.translation)
      )
    })
    
    return tests.shuffled()
  }
  
  // MARK: - Private Methods
  
  private func getRandomAnswers(count: Int, including includedAnswer: String) -> [String] {
    let answers = self.answers
    
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
}
