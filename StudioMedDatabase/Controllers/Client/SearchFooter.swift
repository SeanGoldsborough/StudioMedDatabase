/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class SearchFooter: UIView {
  
  let label: UILabel = UILabel()
    
  var labelText = String()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
  }
  
  func configureView() {
    backgroundColor = UIColor.darkGray
    alpha = 0.0
    
    let topAttributes: [NSAttributedStringKey: Any] =
        [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 17)!,
         NSAttributedStringKey.strikethroughStyle: 0]
    
    
    label.attributedText = NSAttributedString(string: labelText, attributes: topAttributes)
    
    // Configure label
    label.textAlignment = .center
    label.textColor = UIColor.white
    addSubview(label)
  }
  
  override func draw(_ rect: CGRect) {
    label.frame = bounds
  }
  
  //MARK: - Animation
  
  fileprivate func hideFooter() {
    UIView.animate(withDuration: 0.7) {[unowned self] in
      self.alpha = 0.0
    }
  }
  
  fileprivate func showFooter() {
    UIView.animate(withDuration: 0.7) {[unowned self] in
      self.alpha = 1.0
    }
  }
}

extension SearchFooter {
  //MARK: - Public API
  
  public func setNotFiltering() {
    labelText = ""
    hideFooter()
  }
  
  public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
    if (filteredItemCount == totalItemCount) {
      setNotFiltering()
    } else if (filteredItemCount == 0) {
      labelText = "No items match your query"
      showFooter()
    } else {
        labelText = "Results: \(filteredItemCount) of \(totalItemCount)"
      showFooter()
    }
  }

}
