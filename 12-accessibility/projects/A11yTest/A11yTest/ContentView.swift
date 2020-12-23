//
//  ContentView.swift
//  A11yTest
//
//  Created by Audrey Tam on 23/12/20.
//

import SwiftUI

struct ContentView: View {
  @State var showName = false

  var body: some View {
    VStack {
      Spacer()
      Text("Hello, world!")
        .padding()
      if showName {
        Text("Audrey")
      }
      Spacer()
      Button("Show") { showName.toggle() }
        .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
