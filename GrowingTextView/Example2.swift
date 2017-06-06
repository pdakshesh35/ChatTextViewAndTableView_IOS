//
//  Example2.swift
//  GrowingTextView
//
//  Created by Tsang Kenneth on 16/3/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import GrowingTextView

class Example2: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var inputToolbar: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! //*** Bottom Constraint of toolbar ***
    @IBOutlet weak var textView: GrowingTextView!
    var messages = ["daksh", "daksh", "daksh", "daksh"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        // *** Set below parameters in Storyboard ***
        //        textView.delegate = self
        //        textView.layer.cornerRadius = 4.0
        //        textView.maxLength = 200
        //        textView.maxHeight = 70
        //        textView.trimWhiteSpaceWhenEndEditing = true
        //        textView.placeHolder = "Say something..."
        //        textView.placeHolderColor = UIColor(white: 0.8, alpha: 1.0)
        //        textView.placeHolderLeftMargin = 5.0
        //        textView.font = UIFont.systemFont(ofSize: 15)
        
        // *** Listen for keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func textViewDidChange(_ textView: UITextView) {
        print(inputToolbar.frame.size.height)
         tabelView.contentInset = UIEdgeInsetsMake(0, 0, inputToolbar.frame.size.height, 0)
        tableViewScrollToBottom(animated: true)
        self.view.layoutIfNeeded()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            messages.append(textView.text)
            tabelView.reloadData()
        }
        return true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    func keyboardWillChangeFrame(_ notification: Notification) {
        let endFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = UIScreen.main.bounds.height - endFrame.origin.y
        
        if tabelView.contentSize.height > endFrame.height {
         tabelView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.height + inputToolbar.frame.size.height, 0)
        }
        tableViewScrollToBottom(animated: true)
        self.view.layoutIfNeeded()
    }
    
    func tapGestureHandler() {
        view.endEditing(true)
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
     
            
            let numberOfSections = self.tabelView.numberOfSections
            let numberOfRows = self.tabelView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                
                self.tabelView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
            
        
    }
    
    
}


extension Example2: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
