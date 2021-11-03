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

struct CardView: View {
  let flashCard: FlashCard
  @Binding var cardColor: Color
  @State var revealed = false
  @State var offset: CGSize = .zero
  @GestureState var isLongPressed = false
  
  typealias CardDrag = (_ card: FlashCard, _ direction: DiscardedDirection) -> Void
  let dragged: CardDrag
  
  init(_ card: FlashCard, cardColor: Binding<Color>, onDrag dragged: @escaping CardDrag = {_,_  in } ) {
    self.flashCard = card
    self._cardColor = cardColor
    self.dragged = dragged
  }

  func discardCard(to direction: DiscardedDirection) {
    let width: CGFloat
    switch direction {
    case .left: width = -1000
    case .right: width = 1000
    }
    offset = .init(width: width, height: 0)
    dragged(flashCard, direction)
  }
  
  var body: some View {
    let drag = DragGesture()
      .onChanged { offset = $0.translation }
      .onEnded {
        if $0.translation.width < -100 {
          offset = .init(width: -1000, height: 0)
          dragged(flashCard, .left)
        } else if $0.translation.width > 100 {
          offset = .init(width: 1000, height: 0)
          dragged(flashCard, .right)
        } else {
          offset = .zero
        }
      }
    
    let longPress = LongPressGesture()
      .updating($isLongPressed) { value, state, transition in
        state = value
      }
      .simultaneously(with: drag)
    
    return ZStack {
      Rectangle()
        .fill(cardColor)
        .frame(width: 320, height: 210)
        .cornerRadius(12)
      VStack {
        Spacer()
        Text(flashCard.card.question)
          .font(.largeTitle)
          .foregroundColor(.white)
        if revealed {
          Text(flashCard.card.answer)
            .font(.caption)
            .foregroundColor(.white)
        }
        Spacer()
      }
    }
    .shadow(radius: 8)
    .frame(width: 320, height: 210)
    .animation(.spring(), value: offset)
    .offset(offset)
    .gesture(longPress)
    .scaleEffect(isLongPressed ? 1.1 : 1)
    .animation(.easeInOut(duration: 0.3), value: isLongPressed)
    .simultaneousGesture(TapGesture()
      .onEnded {
        withAnimation(.easeIn, {
          revealed.toggle()
        })
    })
  }
}

struct CardView_Previews: PreviewProvider {
  @State static var cardColor = Color.red
  
  static var previews: some View {
    let card = FlashCard(
      card: Challenge(
        question: "こんにちわ",
        pronunciation: "Konnichiwa",
        answer: "Hello"
      )
    )
    return CardView(card, cardColor: $cardColor)
  }
}
