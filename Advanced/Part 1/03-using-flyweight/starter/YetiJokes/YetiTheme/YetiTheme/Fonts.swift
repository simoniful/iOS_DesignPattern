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

import Foundation

/* 직접적으로 Bundle 내 폰트를 등록할 수 있으나, 분리된 번들을 통해서 여러 app에서 사용하고자 하는 경우에 다음과 같이 flyweight 패턴을 통하여 전역적으로 접근할 수 있도록 구성 가능 */

public final class Fonts {
  
  public static let large = loadFont(name: fontName, size: 30.0)
  public static let medium = loadFont(name: fontName, size: 25.0)
  public static let small = loadFont(name: fontName, size: 18.0)
  
  private static let fontName = "coolstory-regular"
  
  private static func loadFont(name: String, size: CGFloat) -> UIFont {
    if let font = UIFont(name: name, size: size) {
      return font
    }
    // 등록된 폰트가 없는 경우 동적으로 등록
    let bundle = Bundle(for: Fonts.self)
    guard let url = bundle.url(forResource: name, withExtension: "ttf"),
          let fontData = NSData(contentsOf: url),
          let provider = CGDataProvider(data: fontData),
          let cgFont = CGFont(provider),
          let fontName = cgFont.postScriptName as String? else {
      preconditionFailure("\(name) 폰트를 불러올 수 없습니다")
    }
    CTFontManagerRegisterGraphicsFont(cgFont, nil)
    return UIFont(name: fontName, size: size)!
  }
}
