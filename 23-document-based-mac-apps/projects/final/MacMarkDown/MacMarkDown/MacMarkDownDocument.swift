//
//  MacMarkDownDocument.swift
//  MacMarkDown
//
//  Created by Sarah Reichelt on 22/8/20.
//

import SwiftUI
import UniformTypeIdentifiers
import MarkdownKit

extension UTType {
    static var markdownText: UTType {
        UTType(importedAs: "net.daringfireball.markdown")
    }
}

struct MacMarkDownDocument: FileDocument {
    @AppStorage("styleSheet") var styleSheet: StyleSheet = .GitHub

    var text: String
    var html: String {
        let markdown = MarkdownParser.standard.parse(text)
        return HtmlGenerator.standard.generate(doc: markdown)
    }

    init(text: String = "# Hello MacMarkDown") {
        self.text = text
    }

    mutating func refreshHtml() {
        let temp = text
        text = ""
        text = temp
    }

    mutating func addMarkdown(_ markdown: String) {
        self.text += markdown
    }

    static var readableContentTypes: [UTType] { [.markdownText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }

}

extension MacMarkDownDocument {

    var completeHTML: String {
        return """
        <!DOCTYPE html>
        <head>
          <meta charset="UTF-8">
        </head>
        <body>
            \(html)
        </body>
        </html>
        """
    }

    var completeHTMLPlusCSS: String {
        var css: String = ""
        let cssUrl = Bundle.main.url(forResource: styleSheet.rawValue, withExtension: "css")
        if let cssUrl = cssUrl {
            do {
                css = try String(contentsOf: cssUrl)
            } catch {
                css = ""
            }
        }

        return """
        <!DOCTYPE html>
        <head>
          <meta charset="UTF-8">
          <style>
            \(css)
          </style>
        </head>
        <body>
            \(html)
        </body>
        </html>
        """
    }
}
