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
import UIKit

extension UIColor {
  convenience init(rgbStruct rgb: RGB) {
    let red = CGFloat(rgb.red) / 255.0
    let green = CGFloat(rgb.green) / 255.0
    let blue = CGFloat(rgb.blue) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}

struct RGB {
  var red = 127
  var green = 127
  var blue = 127

  func difference(target: RGB) -> Double {
    let rDiff = Double(red - target.red)
    let gDiff = Double(green - target.green)
    let bDiff = Double(blue - target.blue)
    return sqrt((rDiff * rDiff + gDiff * gDiff + bDiff * bDiff) / 3.0) / 255.0
  }

  static func random() -> RGB {
    var rgb = RGB()
    rgb.red = Int.random(in: 0..<256)
    rgb.green = Int.random(in: 0..<256)
    rgb.blue = Int.random(in: 0..<256)
    return rgb
  }
}
