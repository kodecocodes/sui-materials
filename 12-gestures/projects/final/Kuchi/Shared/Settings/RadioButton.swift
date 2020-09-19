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

struct RadioButton: View {
  @Environment(\.colorScheme) var colorScheme
  @Binding var isOn: Bool
  let label: String?
  
  init(isOn: Binding<Bool>, label: String? = nil) {
    self._isOn = isOn
    self.label = label
  }
  
  var borderColor: Color {
    switch colorScheme {
    case .dark: return Color.white.opacity(0.4)
    case .light: return Color.black.opacity(0.2)
    @unknown default: return Color.black.opacity(0.2)
    }
  }
  
  var body: some View {
    Button(action: {
      if self.isOn == false {
        self.isOn = true
      }
    }) {
      HStack(alignment: .center) {
        ZStack {
          Circle().fill(isOn ? Color.blue : Color.clear)
          Circle().stroke(borderColor)
          if isOn {
            Image(systemName: "checkmark")
              .foregroundColor(.white)
          }
        }
        .frame(width: 24, height: 24)

        if let label = label {
          Text(label)
            .font(.body)
            .foregroundColor(.primary)
        }
      }
    }
    .buttonStyle(RadioButtonStyle())
  }
}

struct RadioButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .background(Color.clear)
  }
}
struct RadioButton_Previews: PreviewProvider {
  @State static var isOn1: Bool = false
  @State static var isOn2: Bool = true
  static var previews: some View {
    RadioButton(isOn: $isOn1, label: "Option")
    RadioButton(isOn: $isOn2)
  }
}
