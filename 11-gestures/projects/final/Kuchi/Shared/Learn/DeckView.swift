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

enum DiscardedDirection {
  case left
  case right
}

struct DeckView: View {
  @ObservedObject var deck: FlashDeck
  @AppStorage("cardBackgroundColor") var cardBackgroundColorInt: Int = 0xFF0000FF
  let onMemorized: () -> Void
  
  init(deck: FlashDeck, onMemorized: @escaping () -> Void) {
    self.onMemorized = onMemorized
    self.deck = deck
  }
  
  var body: some View {
    ZStack {
      ForEach(deck.cards.filter { $0.isActive }) { card in
        getCardView(for: card)
      }
    }
  }
  
  func getCardView(for card: FlashCard) -> CardView {
    let activeCards = deck.cards.filter { $0.isActive == true }
    if let lastCard = activeCards.last {
      if lastCard == card {
        return createCardView(for: card)
      }
    }
    
    let view = createCardView(for: card)
    
    return view
  }
  
  func createCardView(for card: FlashCard) -> CardView {
    let view = CardView(card, cardColor: Binding(
        get: { Color(rgba: cardBackgroundColorInt) },
        set: { newValue in cardBackgroundColorInt = newValue.asRgba }
      ),
      onDrag: { card, direction in
        if direction == .left {
          onMemorized()
        }
      }
    )
      
    return view
  }
}

struct DeckView_Previews: PreviewProvider {
  static var previews: some View {
    DeckView(
      deck: FlashDeck(from: ChallengesViewModel.challenges),
      onMemorized: {}
    )
  }
}
