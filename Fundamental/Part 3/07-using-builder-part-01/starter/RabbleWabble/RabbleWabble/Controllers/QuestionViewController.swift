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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public protocol QuestionViewControllerDelegate: class {
  func questionViewController(_ viewController: QuestionViewController,
                              didCancel questionStrategy: QuestionStrategy)
  
  func questionViewController(_ viewController: QuestionViewController,
                              didComplete questionStrategy: QuestionStrategy)
}

public class QuestionViewController: UIViewController {

  // MARK: - Instance Properties
  public weak var delegate: QuestionViewControllerDelegate?
    
  public var questionStrategy: QuestionStrategy! {
    didSet {
      navigationItem.title = questionStrategy.title
    }
  }
  
  public var questionView: QuestionView! {
    guard isViewLoaded else { return nil }
    return (view as! QuestionView)
  }
  
  private lazy var questionIndexItem: UIBarButtonItem = { [unowned self] in
    let item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.navigationItem.rightBarButtonItem = item
    return item
  }()
  
  // MARK: - View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    showQuestion()
    setupCancelButton()
  }
  
  private func setupCancelButton() {
    let action = #selector(handleCancelPressed(sender:))
    let image = UIImage(named: "ic_menu")
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                       landscapeImagePhone: nil,
                                                       style: .plain,
                                                       target: self,
                                                       action: action)
  }
  
  @objc private func handleCancelPressed(sender: UIBarButtonItem) {
    delegate?.questionViewController(self, didCancel: questionStrategy)
  }
  
  private func showQuestion() {
    let question = questionStrategy.currentQuestion()
    questionIndexItem.title = questionStrategy.questionIndexTitle()
    
    questionView.answerLabel.text = question.answer
    questionView.promptLabel.text = question.prompt
    questionView.hintLabel.text = question.hint
    
    questionView.answerLabel.isHidden = true
    questionView.hintLabel.isHidden = true
  }
  
  // MARK: - Actions
  @IBAction func toggleAnswerLabels(_ sender: Any) {
    questionView.answerLabel.isHidden = !questionView.answerLabel.isHidden
    questionView.hintLabel.isHidden = !questionView.hintLabel.isHidden
  }
  
  @IBAction func handleCorrect(_ sender: Any) {
    let question = questionStrategy.currentQuestion()
    questionStrategy.markQuestionCorrect(question)
    questionView.correctCountLabel.text = String(questionStrategy.correctCount)
    showNextQuestion()
  }
  
  @IBAction func handleIncorrect(_ sender: Any) {
    let question = questionStrategy.currentQuestion()
    questionStrategy.markQuestionIncorrect(question)
    questionView.incorrectCountLabel.text = String(questionStrategy.incorrectCount)
    showNextQuestion()
  }
  
  private func showNextQuestion() {
    guard questionStrategy.advanceToNextQuestion() else {
      delegate?.questionViewController(self, didComplete: questionStrategy)
      return
    }
    showQuestion()
  }
}
