/// Copyright (c) 2019 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

class FlightHistory : NSObject {
  public var day: Int
  public var flightId: Int
  public var date: Date
  public var direction: FlightDirection
  public var status: FlightStatus
  public var scheduledTime: Date
  public var actualTime: Date?
  
  public var shortDate: String {
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM d"
      return formatter.string(from: date)
    }
  }
  
  public var timeDifference: Int {
    get {
      guard let actual = actualTime else { return 60 }
      let diff = Calendar.current.dateComponents([.minute], from: scheduledTime, to: actual)
      return diff.minute!
    }
  }
  
  public var flightDelayDescription: String {
    if status == .cancelled {
      return "Cancelled"
    }
    
    if timeDifference < 0 {
      return "Early by \(-timeDifference) minutes."
    } else if timeDifference == 0 {
      return "On time"
    } else {
      return "Late by \(timeDifference) minutes."
    }
  }
  
  public var delayColor: Color {
    if status == .cancelled {
      return Color.init(red: 0.5, green: 0, blue: 0)
    }
    
    if timeDifference <= 0 {
      return Color.green
    }
    
    if timeDifference <= 15 {
      return Color.yellow
    }
    
    return Color.red
  }
  
  public func calcOffset(_ width: CGFloat) -> CGFloat {
    return CGFloat(CGFloat(day-1) * width)
  }
  
  init(_ day: Int, id: Int, date: Date, direction: FlightDirection, status: FlightStatus, scheduledTime: Date, actualTime: Date?)
  {
    self.day = day
    self.flightId = id
    self.date = date
    self.direction = direction
    self.status = status
    self.scheduledTime = scheduledTime
    self.actualTime = actualTime
  }
}
