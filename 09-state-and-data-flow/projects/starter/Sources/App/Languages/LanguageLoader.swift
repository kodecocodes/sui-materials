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

import Foundation

import Languages

/// Handles loading of languages from any and all resources.
/// **Note**: Currently this only handles loading local JSON translated word files in JSON.
class LanguageLoader {
  
  /// This is the default singleton instance for language loader. The option is here to split the loaders
  /// for concurrent resource loading in the future.
  static private var `default`: LanguageLoader = LanguageLoader()
  
  /// Loads translated words into the `TranslatedWord` object. Depends on the `Languages` package.
  static func loadTranslatedWords(from fileName: String) -> [TranslatedWord]? {
    LanguageLoader.default.loadTranslatedWords(from: fileName)
  }
  
  /// Initializes a new instance of the `LanguageLoader`. This is privately scoped to restrict accidental
  /// duplication of `LanguageLoader` instances. Modify the scope if you wish to extend the language
  /// loading to concurrent or multi-source imports.
  private init() {}
  
  /// Loads an array of `TranslatedWord` objects from a JSON file into memory.
  ///
  /// If this is unsuccessful the error will be reported to the console but will not be thrown, potentially
  /// causing unpredictable behavior in any data flow which may depend on this data.
  ///
  ///  - parameters:
  ///     - fileName: Name of the (JSON) file to load in JSON.
  ///  - returns: An (optional) array of `TranslatedWord` objects.
  func loadTranslatedWords(from fileName: String) -> [TranslatedWord]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([TranslatedWord].self, from: data)
        return jsonData as [TranslatedWord]
      } catch {
        print("error:\(error)")
      }
    }
    return nil
  }
}
