/// Copyright (c) 2021 Razeware LLC
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

struct SettingsView: View {
  @AppStorage("numberOfQuestions") var numberOfQuestions = 6
  @AppStorage("appearance") var appearance: Appearance = .automatic
  @State var learningEnabled: Bool = true
  @AppStorage("dailyReminderEnabled") var dailyReminderEnabled = false
  @State var dailyReminderTime = Date(timeIntervalSince1970: 0)
  @AppStorage("dailyReminderTime") var dailyReminderTimeShadow: Double = 0
  @State var cardBackgroundColor: Color = .red

  var body: some View {
    List {
      Text("Settings")
        .font(.largeTitle)
        .padding(.bottom, 8)
      
      Section(header: Text("Appearance")) {
        VStack(alignment: .leading) {
          Picker("", selection: $appearance) {
            ForEach(Appearance.allCases) { appearance in
              Text(appearance.name).tag(appearance)
            }          }
          .pickerStyle(SegmentedPickerStyle())
          
          ColorPicker(
            "Card Background Color",
            selection: $cardBackgroundColor
          )
        }
      }
      
      Section(header: Text("Game")) {
        VStack(alignment: .leading) {
          Stepper(
            "Number of Questions: \(numberOfQuestions)",
            value: $numberOfQuestions,
            in: 3 ... 20
          )
          Text("Any change will affect the next game")
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        
        Toggle("Learning Enabled", isOn: $learningEnabled)
      }
      
      Section(header: Text("Notifications")) {
        HStack {
          Toggle("Daily Reminder", isOn: $dailyReminderEnabled)
          DatePicker("", selection: $dailyReminderTime, displayedComponents: .hourAndMinute)
        }
      }
      .onChange(of: dailyReminderEnabled, perform: { _ in configureNotification() })
      .onChange(of: dailyReminderTime, perform: { newValue in
        dailyReminderTimeShadow = newValue.timeIntervalSince1970
        configureNotification()
      })
      .onAppear {
        dailyReminderTime = Date(timeIntervalSince1970: dailyReminderTimeShadow)
      }
    }
  }
  
  func configureNotification() {
    if dailyReminderEnabled {
      LocalNotifications.shared.createReminder(time: dailyReminderTime)
    } else {
      LocalNotifications.shared.deleteReminder()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
