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

import Foundation
import UserNotifications

class LocalNotifications {
  static var shared = LocalNotifications()

  var lastKnownPermission: UNAuthorizationStatus?
  var userNotificationCenter: UNUserNotificationCenter { UNUserNotificationCenter.current() }

  private init() {
    userNotificationCenter.getNotificationSettings { settings in
      let permission = settings.authorizationStatus
      
      switch permission {
        #if os(iOS)
        case .ephemeral, .provisional: fallthrough
        #endif
          
        case .notDetermined:
          self.requestLocalNotificationPermission(completion: { _ in })
          
        case .authorized, .denied:
          break
          
        @unknown default: break
      }
    }
  }
  
  func createReminder(time: Date) {
    deleteReminder()
    userNotificationCenter.getNotificationSettings { settings in
      let content = UNMutableNotificationContent()
      content.title = "Kuchi"
      content.subtitle = "It's time to practice!"
      
      if settings.soundSetting == .enabled {
        content.sound = UNNotificationSound.default
      }
          
      var date = DateComponents()
      date.calendar = Calendar.current
      date.timeZone = TimeZone.current
      date.hour = Calendar.current.component(.hour, from: time)
      date.minute = Calendar.current.component(.minute, from: time)
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
      
      let reminder = UNNotificationRequest(
        identifier: "kuchi-reminder",
        content: content,
        trigger: trigger
      )
      
      self.userNotificationCenter.add(reminder)
    }
  }
  
  func deleteReminder() {
    userNotificationCenter.removeAllDeliveredNotifications()
  }
  
  func requestLocalNotificationPermission(completion: @escaping (_ granted: Bool) -> Void) {
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    userNotificationCenter.requestAuthorization(options: options) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          print(error)
          completion(false)
          return
        }
        
        guard granted else {
          completion(false)
          return
        }
        
        completion(true)
      }
    }
  }
}
