//
//  KuchiApp.swift
//  Shared
//
//  Created by Antonio Bello on 8/16/20.
//

import SwiftUI

@main
struct KuchiApp: App {
  let userManager = UserManager()
  
  init() {
    userManager.load()
  }
  
  var body: some Scene {
    WindowGroup {
      StarterView()
        .environmentObject(userManager)
        .environmentObject(ChallengesViewModel())
    }
  }
}
