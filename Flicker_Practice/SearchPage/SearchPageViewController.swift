//
//  ViewController.swift
//  Flicker_Practice
//
//  Created by tautau on 2020/1/13.
//  Copyright © 2020 tautau. All rights reserved.
//

import UIKit

class SearchPageViewController: UIViewController {

    @IBOutlet var searchKeyTextField: UITextField!
    @IBOutlet var searchAmountTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchKeyTextField.keyboardType = .default
        updateUI()
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToResultView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarVC = segue.destination as? UITabBarController else {fatalError("Fuck")}
        guard let navigationVC = tabBarVC.viewControllers?.first as? UINavigationController else {fatalError("Fuck again")}
        guard let resultVC = navigationVC.viewControllers.first as? SearchResultViewController else {fatalError("fuck fuck")}
        resultVC.controller.searchKey = searchKeyTextField.text
        resultVC.controller.searchAmount = searchAmountTextField.text
        clearTextField()
    }
    
}

extension SearchPageViewController {
    func updateUI() {
        if searchKeyTextField.text == "" || searchAmountTextField.text == "" {
            searchButton.isEnabled = false
            searchButton.backgroundColor = .gray
            searchKeyTextField.placeholder = "輸入收尋關鍵字"
            searchAmountTextField.placeholder = "輸入頁面呈現資料筆數"
        } else {
            searchButton.isEnabled = true
            searchButton.backgroundColor = .systemBlue
        }
    }
    
    func clearTextField() {
        searchKeyTextField.text = ""
        searchAmountTextField.text = ""
        searchKeyTextField.becomeFirstResponder()
    }
}

extension SearchPageViewController:UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
