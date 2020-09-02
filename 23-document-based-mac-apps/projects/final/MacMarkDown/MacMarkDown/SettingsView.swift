//
//  SettingsView.swift
//  MacMarkDown
//
//  Created by Sarah Reichelt on 23/8/20.
//

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
