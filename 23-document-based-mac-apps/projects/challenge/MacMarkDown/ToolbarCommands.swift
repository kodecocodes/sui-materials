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

enum PreviewState {
  case hidden
  case html
  case web
}

struct PreviewToolBarItem: ToolbarContent {
  @Binding var previewState: PreviewState

  var body: some ToolbarContent {
    ToolbarItem {
      Picker("", selection: $previewState) {
        Image(systemName: "eye.slash")
          .tag(PreviewState.hidden)
        Image(systemName: "doc.plaintext")
          .tag(PreviewState.html)
        Image(systemName: "doc.richtext")
          .tag(PreviewState.web)
      }
      .pickerStyle(SegmentedPickerStyle())
      .help("Hide preview, show HTML or web view")
    }
  }
}

// Challenge 1: toolbar items for exporting HTML

struct ExportToolBarItems: ToolbarContent {
  let exportCallback: (Bool) -> Void

  var body: some ToolbarContent {
    ToolbarItemGroup {
      Button(action: { exportCallback(false) }, label: {
        Image(systemName: "arrow.up.doc")
      })
      .help("Export as HTML")

      Button(action: { exportCallback(true) }, label: {
        Image(systemName: "arrow.up.doc.fill")
      })
      .help("Export as HTML with CSS")
    }
  }
}

// Challenge 2: toolbar items for Markdown snippets

struct MarkdownToolBarItems: ToolbarContent {
  let markdownCallback: (String) -> Void

  var body: some ToolbarContent {
    ToolbarItemGroup {
      Spacer()

      Menu("Markdown Snippets") {
        Menu("Headers") {
          Button("Header 1") {
            markdownCallback("# Header 1")
          }
          Button("Header 2") {
            markdownCallback("## Header 2")
          }
          Button("Header 3") {
            markdownCallback("### Header 3")
          }
          Button("Header 4") {
            markdownCallback("#### Header 4")
          }
          Button("Header 5") {
            markdownCallback("##### Header 5")
          }
          Button("Header 6") {
            markdownCallback("###### Header 6")
          }
        }

        Button("Bold") {
          markdownCallback("**BOLD**")
        }.keyboardShortcut("b", modifiers: .command)
        Button("Italic") {
          markdownCallback("_Italic_")
        }.keyboardShortcut("i", modifiers: .command)

        Button("Link") {
          let linkText = "[Title](https://link_to_page)"
          markdownCallback(linkText)
        }.keyboardShortcut("l", modifiers: .command)

        Button("Image") {
          let linkText = "![alt text](https://link_to_image)"
          markdownCallback(linkText)
        }

        Menu("Lists") {
          Button("Unordered") {
            let listText = "- Item 1\n- Item 2\n- Item 3\n"
            markdownCallback(listText)
          }

          Button("Numbered") {
            let listText = "1. Item 1\n2. Item 2\n3. Item 3\n"
            markdownCallback(listText)
          }
        }

        Button("Code") {
          let text = "```\nlet x = 3\n```"
          markdownCallback(text)
        }

        Button("Blockquote") {
          markdownCallback("> Quote")
        }

        Button("Horizontal Rule") {
          markdownCallback("\n---\n")
        }
      }
    }
  }
}
