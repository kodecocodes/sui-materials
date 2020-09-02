//
//  ContentView.swift
//  MacMarkDown
//
//  Created by Sarah Reichelt on 22/8/20.
//

// toobar & HSplitView both mess with the File & Window menus
// Menus not targetting front window

import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("styleSheet") var styleSheet: StyleSheet = .GitHub
    @AppStorage("editorFontName") var editorFontName: String = "System"
    @AppStorage("editorFontSize") var editorFontSize: Int = 14

    @Binding var document: MacMarkDownDocument
    @Binding var documentURL: URL?

    @State private var doneFirstDraw = false
    @State private var previewState = PreviewState.preview
    @State private var isFocused = true
    @State private var showSaveOK = false
    @State private var showSaveError = false

    var editorFont: Font {
        if editorFontName == "System" {
            return .system(size: CGFloat(editorFontSize))
        } else {
            return .custom(editorFontName, size: CGFloat(editorFontSize), relativeTo: .body)
        }
    }

    var fileName: String {
        if let url = documentURL {
            return url.deletingPathExtension().lastPathComponent
        }
        return "Export"
    }

    var body: some View {
        HSplitView {
            TextEditor(text: $document.text)
                .disableAutocorrection(false)
                .font(editorFont)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                .focusable(isFocused, onFocusChange: { focused in
                    // not working yet
                    print("focus changed")
                })

            if previewState != .hidden {
                markdownPreview()
                    .frame(minWidth: 200, maxWidth: .infinity,
                           maxHeight: doneFirstDraw ? .infinity : 0)
                    .transition(.move(edge: .trailing))
                    .onChange(of: styleSheet) { _ in
                        document.refreshHtml()
                    }
            }
        }
        .frame(minWidth: 300, idealWidth: 500, maxWidth: .infinity,
               minHeight: 400, idealHeight: 700, maxHeight: .infinity, alignment: .top)
        .padding(.top, 1)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                doneFirstDraw = true

                if NSFontPanel.sharedFontPanelExists {
                    NSFontPanel.shared.orderOut(nil)
                }
            }
        }
        .toolbar {
            ExportToolBarItems(exportCallback: exportHtml(withCSS:))
            MarkdownToolBarItems(markdownCallback: addMarkdownCallback(markdown:))
            PreviewToolBarItems(previewState: $previewState)
        }
        .onReceive(exportCommand) { exportType in
            // works but applies to every window
            exportHtml(withCSS: exportType == "css")
        }
        .touchBar {
            TouchBarItems(markdownCallback: addMarkdownCallback(markdown:))
        }
    }

    func markdownPreview() -> some View {
        Group {
            if previewState == .rawHtml {
                ScrollView {
                    Text(document.html)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .font(editorFont)
                        .multilineTextAlignment(.leading)
                }
            } else {
                WebView(html: document.html)
            }
        }
    }

    func addMarkdownCallback(markdown: String) {
        document.addMarkdown(markdown)
    }

    func exportHtml(withCSS: Bool) {
        let panel = NSSavePanel()
        panel.nameFieldLabel = "Save HTML as:"
        panel.nameFieldStringValue = "\(fileName).html"
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let doc = MacMarkDownDocument()
        return ContentView(document: .constant(doc), documentURL: .constant(nil))
    }
}
