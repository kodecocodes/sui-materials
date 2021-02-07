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

// Challenge 3: touch bar items

struct TouchBarItems: View {
  let markdownCallback: (String) -> Void

  var body: some View {
    Button("H1") {
      markdownCallback("# Header 1")
    }
    Button("H2") {
      markdownCallback("## Header 2")
    }
    Button("H3") {
      markdownCallback("### Header 3")
    }

    Button("Bold") {
      markdownCallback("**BOLD**")
    }
    Button("Italic") {
      markdownCallback("_Italic_")
    }

    Button("Link") {
      let linkText = "[Title](https://link_to_page)"
      markdownCallback(linkText)
    }

    Button("Image") {
      let linkText = "![alt text](https://link_to_image)"
      markdownCallback(linkText)
    }

    Button("List") {
      let listText = "- Item 1\n- Item 2\n- Item 3\n"
      markdownCallback(listText)
    }

    Button("Code") {
      let text = "```\nlet x = 3\n```"
      markdownCallback(text)
    }

    Button("HR") {
      markdownCallback("\n---\n")
    }
  }
}
