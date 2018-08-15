//
//  SearchViewController.swift
//  spott
//
//  Created by Varun Iyer on 7/31/18.
//  Copyright © 2018 Spott. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var searchTextField: UITextField!
    var searchTableView: UITableView!
    var searchValues: [String] = []
    var allValues: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        B.mapViewController.searchButton.removeFromSuperview()
        B.mapViewController.searchBlurView.snp.remakeConstraints{ (make) in
            make.centerX.equalTo(B.mapViewController.view.snp.centerX)
            make.top.equalTo(B.mapViewController.view.snp.top).offset(-200)
            make.width.equalTo(B.mapViewController.view.snp.width)
            make.bottom.equalTo(B.mapViewController.view.snp.centerY).offset(-50)
        }
        
        searchTextField = UITextField()
        searchTextField.autocapitalizationType = .none
        searchTextField.backgroundColor = UIColor.clear
        searchTextField.keyboardType = UIKeyboardType.default
        searchTextField.returnKeyType = UIReturnKeyType.next
        searchTextField.autocorrectionType = UITextAutocorrectionType.no
        searchTextField.textAlignment = .center
        searchTextField.font = UIFont(name: "FuturaPT-Light", size: 25.0)
        searchTextField.defaultTextAttributes.updateValue(3, forKey: NSAttributedStringKey.kern.rawValue)
        searchTextField.becomeFirstResponder()
        
        searchTableView = UITableView()
        searchTableView.separatorColor = UIColor.clear
        searchTableView.backgroundColor = UIColor.clear
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTableView.separatorInset = UIEdgeInsets.zero
        
        searchTextField.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(25)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(50)
        }
        
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.width.equalTo(self.view.snp.width)
            make.bottom.equalTo(self.view.snp.centerY).offset(-60)
        }
    }
}

extension SearchViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        cell.textLabel?.text = searchValues[indexPath.row].lowercased()
        cell.textLabel?.font = searchTextField.font
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        searchTextField.text = searchValues[indexPath.row].lowercased()
        searchTableView.isHidden = true
        B.mapViewController.searchBlurView.snp.remakeConstraints{ (make) in
            make.centerX.equalTo(B.mapViewController.view.snp.centerX)
            make.top.equalTo(B.mapViewController.view.snp.top).offset(-200)
            make.width.equalTo(B.mapViewController.view.snp.width)
            make.bottom.equalTo(B.mapViewController.view.snp.top).offset(110)
        }
        searchTextField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Finish Editing The Text Field
    /*func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
        
        for annotation in self.mapView.annotations!
        {
            if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 1
            {
                if textField.text == (annotation as! MapAnnotation).user.name.lowercased()
                {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
            if annotation.isKind(of: MapAnnotation.self) && ((annotation as! MapAnnotation).type == 2 || (annotation as! MapAnnotation).type == 3)
            {
                if textField.text == (annotation as! MapAnnotation).user.name.lowercased()
                {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
            else if annotation.isKind(of: MapAnnotation.self) && (annotation as! MapAnnotation).type == 0
            {
                if textField.text == (annotation as! MapAnnotation).location.name.lowercased()
                {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
    }*/
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string == ""
        {
            searchValues = allValues
        }
        else
        {
            if let text = textField.text, let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                self.searchValues = []
                for v in allValues
                {
                    if v.lowercased().range(of: updatedText.lowercased()) != nil
                    {
                        searchValues.append(v)
                    }
                }
            }
        }
        self.searchTableView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
