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

struct RGB {
  var red = 0.5
  var green = 0.5
  var blue = 0.5

  /// Create an RGB object with random values.
  static func random() -> RGB {
    var rgb = RGB()
    rgb.red = Double.random(in: 0..<1)
    rgb.green = Double.random(in: 0..<1)
    rgb.blue = Double.random(in: 0..<1)
    return rgb
  }

  /// Compute the normalized 3-dimensional distance to another RGB object.
  ///   - parameters:
  ///     - target: The other RGB object.
  func difference(target: RGB) -> Double {
    let rDiff = red - target.red
    let gDiff = green - target.green
    let bDiff = blue - target.blue
    return sqrt(
      (rDiff * rDiff + gDiff * gDiff + bDiff * bDiff) / 3.0)
  }

  var rInt: Int {
    Int(red * 255.0)
  }
  var gInt: Int {
    Int(green * 255.0)
  }
  var bInt: Int {
    Int(blue * 255.0)
  }

  /// A String representing the integer values of an RGB instance.
  var intString: String {
    "R \(rInt) G \(gInt) B \(bInt)"
  }

  var accString: String {
    "Red \(rInt), Green \(gInt), Blue \(bInt)."
  }
}
