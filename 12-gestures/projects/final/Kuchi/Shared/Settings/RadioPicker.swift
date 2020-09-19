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

class RadioPickerState<SelectionValue: Hashable>: ObservableObject {
  var currentSelectedIndex: Int?
  var values: [SelectionValue]
  
  var selection: Binding<SelectionValue>
  
  @Published var isOn: [Bool] = [] {
    willSet {
      guard currentSelectedIndex == nil else { return }
      
      if let currentSelectedIndex = isOn.firstIndex(where: { $0 == true }) {
        self.currentSelectedIndex = currentSelectedIndex
      }
    }
    didSet {
      if let currentSelectedIndex = self.currentSelectedIndex, isOn[currentSelectedIndex] == true {
        isOn[currentSelectedIndex] = false
        self.currentSelectedIndex = nil
        if let selectedIndex = isOn.firstIndex(where: { $0 == true }) {
          selection.wrappedValue = self.values[selectedIndex]
        }
      }
    }
  }
  
  init(selection: Binding<SelectionValue>, values: [SelectionValue]) {
    self.values = values
    self.isOn = Array(repeating: false, count: values.count)
    self.selection = selection
  }
}

private struct _RadioOption<Value: Hashable>: View {
  let option: RadioOption<Value>
  @Binding var isOn: Bool
  
  var body: some View {
    VStack {
      option
      RadioButton(isOn: $isOn)
    }
  }
}


@_functionBuilder
struct RadioOptionBuilder<Value: Hashable> {
  static func buildBlock(_ children: RadioOption<Value>...) -> [RadioOption<Value>] {
    return children
  }
}

struct RadioPicker<Label: View, SelectionValue: Hashable>: View {
  @ObservedObject private var pickerState: RadioPickerState<SelectionValue>
  private let label: Label
  private let options: [RadioOption<SelectionValue>]
  
  var selection: Binding<SelectionValue> {
    get { $pickerState.selection.wrappedValue }
    set {
      guard let index = options.firstIndex(where: { $0.value.hashValue == newValue.wrappedValue.hashValue}) else { return }
      pickerState.isOn[index] = true
      pickerState.selection = newValue
    }
  }
  
  init(
    selection: Binding<SelectionValue>,
    label: Label,
    @RadioOptionBuilder<SelectionValue> content: () -> [RadioOption<SelectionValue>]
  ) {
    self.label = label
    
    self.options = content()
    self.pickerState = RadioPickerState(
      selection: selection,
      values: content().map { $0.value }
    )
    self.selection = selection
  }
  
  var body: some View {
    VStack {
      label
      ScrollView(.horizontal) {
        HStack(spacing: 16) {
          ForEach (0 ..< options.count) { index in
            _RadioOption(option: options[index], isOn: $pickerState.isOn[index])
          }
        }
        .padding()
      }
    }
  }
}

struct RadioSelector_Previews: PreviewProvider {
  enum Selection: Int, Hashable, Identifiable {
    case one, two, three, four, five, six, seven, eight
    var id: Int { self.rawValue }
  }
  
  @State static var selection: Selection = .one
  
  static var previews: some View {
    RadioPicker(selection: $selection, label: Text("Selection")) {
      RadioOption("One", systemImageName: "1.square", value: Selection.one)
      RadioOption("Two", systemImageName: "2.square", value: Selection.two)
      RadioOption("Three", systemImageName: "3.square", value: Selection.three)
      RadioOption("Four", systemImageName: "4.square", value: Selection.four)
      RadioOption("Five", systemImageName: "5.square", value: Selection.five)
      RadioOption("Six", systemImageName: "6.square", value: Selection.six)
      RadioOption("Seven", systemImageName: "7.square", value: Selection.seven)
      RadioOption("Height", systemImageName: "8.square", value: Selection.eight)
    }
  }
}
