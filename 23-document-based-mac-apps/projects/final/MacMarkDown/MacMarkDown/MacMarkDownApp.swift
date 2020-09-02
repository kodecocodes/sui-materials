//
//  MacMarkDownApp.swift
//  MacMarkDown
//
//  Created by Sarah Reichelt on 22/8/20.
//

import SwiftUI
import Combine

@main
struct MacMarkDownApp: App {

    var body: some Scene {
        DocumentGroup(newDocument: MacMarkDownDocument()) { file in
            ContentView(document: file.$document, documentURL: .constant(file.fileURL))
        }
        .commands {
            MenuCommands()
        }

        Settings {
            SettingsView()
        }
    }

}
