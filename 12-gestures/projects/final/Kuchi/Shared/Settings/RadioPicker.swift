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

struct RadioPicker<Label, SelectionValue, Content>: View where Label: View, SelectionValue: Hashable, Content: View {

  @Binding private var selection: SelectionValue
  private let label: Label
  private var content: Content
  
  init(selection: Binding<SelectionValue>, label: Label, @ViewBuilder content: () -> Content) {
    self._selection = selection
    self.label = label
    self.content = content()
  }
  
  var body: some View {
    VStack {
      label
      HStack {
        content
      }
    }
  }
}

extension RadioPicker where Label == Text {
  init<S>(_ title: S, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where S : StringProtocol {
    self.init(selection: selection, label: Text(title), content: content)
  }
}

struct RadioSelector_Previews: PreviewProvider {
  enum Selection: Int, Hashable, Identifiable {
    case one, two
    var id: Int { self.rawValue }
  }
  
  @State static var selection: Selection = .one
  
  static var previews: some View {
    RadioPicker(selection: $selection, label: Text("Selection")) {
      RadioOption("One", systemImageName: "1.square").tag(Selection.one)
      RadioOption("Two", systemImageName: "2.square").tag(Selection.two)
    }
  }
}
