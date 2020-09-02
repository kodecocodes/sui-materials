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
import Combine

let exportCommand = PassthroughSubject<String, Never>()

struct MenuCommands : Commands {

  var body: some Commands {
    CommandGroup(replacing: CommandGroupPlacement.importExport) {
      Button("Export HTML") {
        exportCommand.send("html")
      }
      Button("Export HTML with CSS") {
        exportCommand.send("css")
      }
    }

    CommandGroup(before: CommandGroupPlacement.help) {
      Button("Markdown Cheatsheet") {
        showCheatSheet()
      }
      Divider()
    }

    //        CommandMenu("Markdown") {
    //            Menu("Headers") {
    //                Button("Header 1") {
    //                    addToClipboardAndPaste(text: "# Header 1")
    //                }.keyboardShortcut(KeyEquivalent("1"), modifiers: .command)
    //                Button("Header 2") {
    //                    addToClipboardAndPaste(text: "## Header 2")
    //                }.keyboardShortcut(KeyEquivalent("2"), modifiers: .command)
    //                Button("Header 3") {
    //                    addToClipboardAndPaste(text: "### Header 3")
    //                }.keyboardShortcut(KeyEquivalent("3"), modifiers: .command)
    //                Button("Header 4") {
    //                    addToClipboardAndPaste(text: "#### Header 4")
    //                }.keyboardShortcut(KeyEquivalent("4"), modifiers: .command)
    //                Button("Header 5") {
    //                    addToClipboardAndPaste(text: "##### Header 5")
    //                }.keyboardShortcut(KeyEquivalent("5"), modifiers: .command)
    //                Button("Header 6") {
    //                    addToClipboardAndPaste(text: "###### Header 6")
    //                }.keyboardShortcut(KeyEquivalent("6"), modifiers: .command)
    //            }
    //
    //            Button("Bold") {
    //                addToClipboardAndPaste(text: "**BOLD**")
    //            }.keyboardShortcut(KeyEquivalent("b"), modifiers: .command)
    //            Button("Italic") {
    //                addToClipboardAndPaste(text: "*Italic*")
    //            }.keyboardShortcut(KeyEquivalent("i"), modifiers: .command)
    //
    //            Button("Link") {
    //                let linkText = "[Title](https://link_to_page)"
    //                addToClipboardAndPaste(text: linkText)
    //            }.keyboardShortcut(KeyEquivalent("l"), modifiers: .command)
    //
    //            Button("Image") {
    //                let linkText = "![alt text](https://link_to_image)"
    //                addToClipboardAndPaste(text: linkText)
    //            }
    //
    //            Menu("Lists") {
    //                Button("Unordered") {
    //                    let listText = "- Item 1\n- Item 2\n- Item 3\n"
    //                    addToClipboardAndPaste(text: listText)
    //                }
    //
    //                Button("Numbered") {
    //                    let listText = "1. Item 1\n2. Item 2\n3. Item 3\n"
    //                    addToClipboardAndPaste(text: listText)
    //                }
    //            }
    //
    //            Button("Code") {
    //                let text = "```\nlet x = 3\n```"
    //                addToClipboardAndPaste(text: text)
    //            }
    //
    //            Button("Blockquote") {
    //                addToClipboardAndPaste(text: "> Quote")
    //            }
    //
    //            Button("Horizontal Rule") {
    //                addToClipboardAndPaste(text: "\n---\n")
    //            }.keyboardShortcut(KeyEquivalent("h"), modifiers: .command)
    //        }

  }

  //    func addToClipboardAndPaste(text: String) {
  //        let oldPaste = NSPasteboard.general.string(forType: .string) ?? ""
  //        NSPasteboard.general.clearContents()
  //        NSPasteboard.general.setString(text, forType: .string)
  //        doPaste()
  //
  //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
  //            NSPasteboard.general.setString(oldPaste, forType: .string)
  //        }
  //    }
  //
  //    // this requires Accessibility features
  //    func doPaste() {
  //        sendCommandKey(keycode: 9)
  //    }
  //
  //    func sendCommandKey(keycode: UInt16) {
  //        let commandKeyCode: UInt16 = 55
  //
  //        let commandDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: commandKeyCode, keyDown: true)
  //        commandDownEvent?.flags = CGEventFlags.maskCommand
  //        commandDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
  //
  //        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: true)
  //        keyDownEvent?.flags = CGEventFlags.maskCommand
  //        keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
  //
  //        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: false)
  //        keyUpEvent?.flags = CGEventFlags.maskCommand
  //        keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
  //
  //        let commandUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: commandKeyCode, keyDown: false)
  //        commandUpEvent?.flags = CGEventFlags.maskCommand
  //        commandUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
  //    }

  func showCheatSheet() {
    let cheatSheetAddress = "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"
    guard let url = URL(string: cheatSheetAddress) else {
      fatalError()
    }
    NSWorkspace.shared.open(url)
  }
}

