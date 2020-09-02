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

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 30) {
            GroupBox(label: Text("Editor Settings:")) {
                EditorSettings()
                    .padding()
                    .frame(width: 340)
            }

            GroupBox(label: Text("Preview Settings")) {
                HtmlPreviewSettings()
                    .padding()
                    .frame(width: 340)

            }

        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

class FontManagerDelegate {
    @AppStorage("editorFontName") var editorFontName: String = "system"
    @AppStorage("editorFontSize") var editorFontSize: Int = 14

    @objc func fontChanged(_ sender: NSFontManager) {
        let newFont = sender.convert(NSFont.systemFont(ofSize: 13.0))
        editorFontName = newFont.fontName
        editorFontSize = Int(newFont.pointSize)
    }
}

struct EditorSettings: View {
    @AppStorage("editorFontName") var editorFontName: String = "System"
    @AppStorage("editorFontSize") var editorFontSize: Int = 14

    @State private var fontManagerDelegate = FontManagerDelegate()
    @State private var fontMenuSize = 4

    var body: some View {
        VStack(spacing: 20) {
            Text("Editor Font: \(editorFontName) \(editorFontSize)")

            HStack() {
                Button("Use System Font") {
                    editorFontName = "System"
                    editorFontSize = fontMenuSize + 10
                }
                Picker("", selection: $fontMenuSize) {
                    ForEach(10 ..< 31) { size in
                        Text("\(size)")
                    }
                }
                .frame(maxWidth: 70)
                .onAppear {
                    fontMenuSize = editorFontSize - 10
                }
                .onChange(of: fontMenuSize) { value in
                    editorFontSize = fontMenuSize + 10
                }
                Text("points")
            }

            Button("Select Custom Font") {
                let fontManager = NSFontManager.shared
                fontManager.target = fontManagerDelegate
                fontManager.action = #selector(fontManagerDelegate.fontChanged(_:))

                let panel = NSFontPanel.shared
                if let selectedFont = NSFont(name: editorFontName, size: CGFloat(editorFontSize)) {
                    panel.setPanelFont(selectedFont, isMultiple: false)
                } else {
                    panel.setPanelFont(NSFont.systemFont(ofSize: CGFloat(editorFontSize)),
                                       isMultiple: false)
                }
                panel.orderFront(nil)
            }
        }
    }
}

struct HtmlPreviewSettings: View {
    @AppStorage("styleSheet") var styleSheet: StyleSheet = .GitHub

    var body: some View {
        VStack {
            Text("Select a style sheet:")
            Picker("", selection: $styleSheet) {
                ForEach(StyleSheet.allCases, id: \.self) { styleSheet in
                    Text(styleSheet.rawValue)
                }
            }
            .pickerStyle(RadioGroupPickerStyle())
        }
    }
}
