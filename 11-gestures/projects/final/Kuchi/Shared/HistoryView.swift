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

struct History: Hashable {
  let date: Date
  let challenge: Challenge
  
  static func random() -> History {
    let date = Date.init(timeIntervalSinceNow: -TimeInterval.random(in: 0...1000000))
    
    let challenge = ChallengesViewModel.challenges.randomElement()!
    
    return History(
      date: date,
      challenge: challenge
    )
  }
  
  static func random(count: Int) -> [History] {
    return (0 ..< count)
      .map({ _ in self.random() })
      .sorted(by: { $0.date < $1.date })
  }
}

struct HistoryView: View {
  let history = History.random(count: 2000)
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }()
  
  var header: some View {
    Text("History")
      .foregroundColor(.white)
      .font(.title)
#if os(iOS)
      .frame(width: UIScreen.main.bounds.width, height: 50)
#endif
      .background(Color.gray)
  }
  
  func getElement(_ element: History) -> some View {
    VStack(alignment: .center) {
      Text("\(dateFormatter.string(from: element.date))")
        .font(.caption2)
        .foregroundColor(.blue)
      HStack {
        VStack {
          Text("Question:")
            .font(.caption)
            .foregroundColor(.gray)
          Text(element.challenge.question)
            .font(.body)
        }
        
        VStack {
          Text("Answer:")
            .font(.caption)
            .foregroundColor(.gray)
          Text(element.challenge.answer)
            .font(.body)
        }
        
        VStack {
          Text("Guessed")
            .font(.caption)
            .foregroundColor(.gray)
          Text(element.challenge.succeeded ? "yes" : "no")
        }
      }
    }
    .padding()
#if os(iOS)
    .frame(width: UIScreen.main.bounds.width)
#endif
  }
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
        Section(header: header) {
          ForEach(history, id: \.self) { element in
            getElement(element)
          }
        }
      }
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}
