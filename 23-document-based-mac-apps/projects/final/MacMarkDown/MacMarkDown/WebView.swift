//
//  WebView.swift
//  MacMarkDown
//
//  Created by Sarah Reichelt on 22/8/20.
//

import SwiftUI
import WebKit

// this is misplaced at the bottom of the view on first load
//      seems to be fixed with a delay setting the height
// needs to divert external links to Safari


final class WebView: NSViewRepresentable {
    @AppStorage("styleSheet") var styleSheet: StyleSheet = .GitHub

    class Coordinator: NSObject, WKNavigationDelegate {
        var embedded: WebView

        init(_ embedded: WebView) {
            self.embedded = embedded
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                if let _ = url.host {
                    // only allow local loads, others load in default browser
                    NSWorkspace.shared.open(url)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }

    var html: String
    var formattedHtml: String {
        return formatHtml(html, styleSheet: styleSheet.rawValue)
    }

    init(html: String) {
        self.html = html
    }

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString(formattedHtml, baseURL: Bundle.main.resourceURL)
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(formattedHtml, baseURL: Bundle.main.resourceURL)
    }

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func formatHtml(_ html: String, styleSheet: String) -> String {
        let fullHtml = """
        <html>
        <head>
        <meta charset="UTF-8">
        <link href="\(styleSheet).css" rel="stylesheet">
        </head>
        <body>
        \(html)
        </body>
        </html>
        """
        return fullHtml
    }
}
