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

struct ContentView: View {
  @Binding var document: MacMarkDownDocument

  @AppStorage("editorFontSize") var editorFontSize: Int = 14
  @AppStorage("styleSheet") var styleSheet: StyleSheet = .github

  @State private var previewState = PreviewState.web

  var body: some View {
    HSplitView {
      TextEditor(text: $document.text)
        .font(.system(size: CGFloat(editorFontSize)))
        .frame(minWidth: 200)

      if previewState == .web {
        WebView(html: document.html)
          .frame(minWidth: 200)
          .onChange(of: styleSheet) { _ in
            document.refreshHtml()
          }
      } else if previewState == .html {
        // swiftlint:disable indentation_width
        ScrollView {
          Text(document.html)
            .frame(minWidth: 200)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topLeading)
            .padding()
            .font(.system(size: CGFloat(editorFontSize)))
        }
      }
    }
    .frame(minWidth: 400,
           idealWidth: 600,
           maxWidth: .infinity,
           minHeight: 300,
           idealHeight: 400,
           maxHeight: .infinity)
    // swiftlint:enable indentation_width

    .toolbar {
      // Challenge 1: export html with or without CSS
      ExportToolBarItems(exportCallback: exportHtml(withCSS:))

      // Challenge 2: Markdown snippets
      MarkdownToolBarItems { markdown in
        document.text += markdown
      }

      PreviewToolBarItem(previewState: $previewState)
    }
    // Challenge 3: Touchbar - in Xcode, choose Window > Touch Bar > Show Touch Bar to show
    .touchBar {
      TouchBarItems { markdown in
        document.text += markdown
      }
    }
  }

  func exportHtml(withCSS: Bool) {
    let panel = NSSavePanel()
    panel.nameFieldLabel = "Save HTML as:"
    panel.nameFieldStringValue = "Export.html"
    panel.canCreateDirectories = true

    panel.begin { response in
      if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
        writeExport(url: fileUrl, withCSS: withCSS)
      }
    }
  }

  func writeExport(url: URL, withCSS: Bool) {
    let html = withCSS ? document.completeHTMLPlusCSS : document.completeHTML

    do {
      try html.write(to: url, atomically: true, encoding: .utf8)
    } catch {
      print(error)
    }
  }
}

struct ContentViewPreviews: PreviewProvider {
  static var previews: some View {
    ContentView(document: .constant(MacMarkDownDocument()))
  }
}
