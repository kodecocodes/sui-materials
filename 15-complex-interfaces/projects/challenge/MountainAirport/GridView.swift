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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct GridView<Content, T>: View where Content: View {
  var columns: Int
  var items: [T]
  let content: (CGFloat, T) -> Content
  
  init(columns: Int, items: [T],
       @ViewBuilder content: @escaping (CGFloat, T) -> Content) {
    self.columns = columns
    self.items = items
    self.content = content
  }
  
  var numberRows: Int {
    guard  items.count > 0 else {
      return 0
    }
    
    return (items.count - 1) / columns + 1
  }
  
  func elementFor(row: Int, column: Int) -> Int? {
    let index = row * self.columns + column
    return index < items.count ? index : nil
  }
  
  var body: some View {
    GeometryReader { geometry in
      
      ScrollView {
        // 1
        ForEach(0..<self.numberRows) { row in
          HStack {
            ForEach(0..<self.columns) { column in
              Group {
                if self.elementFor(row: row, column: column) != nil {
                  self.content(geometry.size.width / CGFloat(self.columns),
                               self.items[self.elementFor(row: row, column: column)!])
                    .frame(width: geometry.size.width / CGFloat(self.columns),
                           height: geometry.size.width / CGFloat(self.columns))
                } else {
                  Spacer()
                }
              }
            }
          }
        }
      }
    }
  }
}

struct GridView_Previews: PreviewProvider {
  static var previews: some View {
    GridView(columns: 3, items: [11, 3, 7, 17, 5, 2, 1]) { gridWidth, item in
      Text("\(item)")
        .frame(width: gridWidth, height: gridWidth)
    }
  }
}
