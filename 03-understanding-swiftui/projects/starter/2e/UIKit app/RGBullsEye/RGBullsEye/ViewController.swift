/// Copyright (c) 2020 Razeware LLC
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

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var targetTextLabel: UILabel!
  @IBOutlet weak var guessLabel: UILabel!
  
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  let game = BullsEyeGame()
  var rgb = RGB()
  
  @IBAction func aSliderMoved(sender: UISlider) {
    switch sender {
    case redSlider:
      rgb.r = Int(sender.value)
      redLabel.text = "R \(rgb.r)"
    case greenSlider:
      rgb.g = Int(sender.value)
      greenLabel.text = "G \(rgb.g)"
    case blueSlider:
      rgb.b = Int(sender.value)
      blueLabel.text = "B \(rgb.b)"
    default: break
    }
    guessLabel.backgroundColor = UIColor(rgbStruct: rgb)
  }
  
  @IBAction func showAlert(sender: AnyObject) {
    // display target values beneath target color
    targetTextLabel.text = "R \(game.targetValue.r)   G \(game.targetValue.g)   B \(game.targetValue.b)"
    
    let difference = game.checkGuess(guess: rgb, target: game.targetValue)
    var title = "Try harder"  // default title if difference >= 10
    if difference == 0 {
      title = "Perfect!"
    } else if difference < 5 {
      title = "So close!"
    } else if difference < 10 {
      title = "Not bad"
    }
    
    let message = "you scored \(game.scoreRound) points"
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: { action in
      self.game.startNewRound()
      self.updateView()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func startOver(sender: AnyObject) {
    game.startNewGame()
    updateView()
  }
  
  func updateView() {
    targetLabel.backgroundColor = UIColor(rgbStruct: game.targetValue)
    targetTextLabel.text = "match this color"
    
    rgb = game.startValue
    guessLabel.backgroundColor = UIColor(rgbStruct: rgb)
    redLabel.text = "R \(rgb.r)"
    greenLabel.text = "G \(rgb.g)"
    blueLabel.text = "B \(rgb.b)"
    
    redSlider.value = Float(rgb.r)
    greenSlider.value = Float(rgb.g)
    blueSlider.value = Float(rgb.b)
    
    roundLabel.text = "Round: \(game.round)"
    scoreLabel.text = "Score: \(game.scoreTotal)"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateView()
  }
}

