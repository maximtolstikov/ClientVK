//
//  ViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 26/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на уведомления клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHiden),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: kbSize.height,
                                         right: 0.0)
        
        // добавляем отступ внизу scrollView равный высоте клавиатуры
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // когда клавиатура исчезает
    @objc func keyboardWillBeHiden(notification: Notification) {
        
        // устанавливаем отступ внизу равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // скрывает клавиатуру
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
        // получаем значение полей
        let login = loginTextField.text
        let password = passwordTextField.text
        
        if login == "admin" && password == "1234" {
            print("auth success!")
        } else {
            print("auth failure!")
        }
    }
    
}
