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

struct ExportToolBarItems : ToolbarContent {
    let exportCallback: (Bool) -> ()

    var body: some ToolbarContent {
        ToolbarItem {
            Button(action: { exportCallback(false) }) {
                Image(systemName: "arrow.up.doc")
            }
            .help("Export as HTML")
        }
        ToolbarItem {
            Button(action: { exportCallback(true) }) {
                Image(systemName: "arrow.up.doc.fill")
            }
            .help("Export as HTML with CSS")
        }
    }
}

struct MarkdownToolBarItems : ToolbarContent {
    let markdownCallback: (String) -> ()

    var body: some ToolbarContent {
        ToolbarItemGroup {
            Spacer()

            Menu("Markdown Snippets") {
                Menu("Headers") {
                    Button("Header 1") {
                        markdownCallback("# Header 1")
                    }.keyboardShortcut("1", modifiers: .command)
                    Button("Header 2") {
                        markdownCallback("## Header 2")
                    }.keyboardShortcut("2", modifiers: .command)
                    Button("Header 3") {
                        markdownCallback("### Header 3")
                    }.keyboardShortcut("3", modifiers: .command)
                    Button("Header 4") {
                        markdownCallback("#### Header 4")
                    }.keyboardShortcut("4", modifiers: .command)
                    Button("Header 5") {
                        markdownCallback("##### Header 5")
                    }.keyboardShortcut("5", modifiers: .command)
                    Button("Header 6") {
                        markdownCallback("###### Header 6")
                    }.keyboardShortcut("6", modifiers: .command)
                }

                Button("Bold") {
                    markdownCallback("**BOLD**")
                }.keyboardShortcut("b", modifiers: .command)
                Button("Italic") {
                    markdownCallback("*Italic*")
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

struct PreviewToolBarItems : ToolbarContent {
    @Binding var previewState: PreviewState

    var body: some ToolbarContent {
        ToolbarItemGroup {
            Spacer()

            Picker("", selection: $previewState) {
                Image(systemName: "eye.slash").tag(PreviewState.hidden)
                    .help("Hide Preview")
                Image(systemName: "doc.plaintext").tag(PreviewState.rawHtml)
                    .help("Show Raw HTML")
                Image(systemName: "doc.richtext").tag(PreviewState.preview)
                    .help("Show Preview")
            }
            .pickerStyle(SegmentedPickerStyle())
            .help("Hide preview, show HTML or web view")
        }
    }
}

enum PreviewState {
    case hidden
    case rawHtml
    case preview
}
