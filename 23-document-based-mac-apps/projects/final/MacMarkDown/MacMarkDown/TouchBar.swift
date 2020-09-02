//
//  TouchBar.swift
//  MacMarkDown
//
//  Created by Sarah Reichelt on 31/8/20.
//

import SwiftUI

struct TouchBarItems : View {
    let markdownCallback: (String) -> ()
    
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
            markdownCallback("*Italic*")
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
