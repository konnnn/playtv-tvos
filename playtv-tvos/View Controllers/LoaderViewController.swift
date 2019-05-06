//
//  LoaderViewController.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 24.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
import GameController

class LoaderViewController: GCEventViewController {
    
    // MARK: - Set Up Views, Labels and etc
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новый плейлист"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.sansNarrowBold(size: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorYellow: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FFEC00")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 24
        textField.layer.backgroundColor = UIColor(hexString: "#3E4157").cgColor
        
        textField.font = UIFont.sansNarrowRegular(size: 30)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "Название плейлиста"
        textField.keyboardAppearance = .dark
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let urlTextField: UITextField = {
        let textField = UITextField()
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 24
        textField.layer.backgroundColor = UIColor(hexString: "#3E4157").cgColor
        
        textField.font = UIFont.sansNarrowRegular(size: 30)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.placeholder = "URL-адрес"
        textField.keyboardAppearance = .dark
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let textFieldNameLabel: UILabel = {
        let label = UILabel()
        label.text = "введите название плейлиста"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.sansNarrowBold(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textFieldURLLabel: UILabel = {
        let label = UILabel()
        label.text = "введите url-адрес плейлиста"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.sansNarrowBold(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 24
        button.layer.backgroundColor = UIColor(hexString: "#3E4157").cgColor
        
        let disabledAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#888994"), NSAttributedString.Key.font: UIFont.sansNarrowBold(size: 24)]
        let disabledAttributedString = NSAttributedString(string: "Сохранить".uppercased(), attributes: disabledAttribute)
        let normaldAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3E4157"), NSAttributedString.Key.font: UIFont.sansNarrowBold(size: 24)]
        let normalAttributedString = NSAttributedString(string: "Сохранить".uppercased(), attributes: normaldAttribute)
        button.isEnabled = false
        button.setAttributedTitle(disabledAttributedString, for: .disabled)
        button.setAttributedTitle(normalAttributedString, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downloaderBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.7)
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Views Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientToViewController()
        
        downloaderBox.addSubview(titleLabel)
        downloaderBox.addSubview(separatorYellow)
        downloaderBox.addSubview(nameTextField)
        downloaderBox.addSubview(textFieldNameLabel)
        downloaderBox.addSubview(urlTextField)
        downloaderBox.addSubview(textFieldURLLabel)
        downloaderBox.addSubview(saveButton)
        self.view.insertSubview(downloaderBox, at: Layer.DownloaderBox.order())
        
        nameTextField.delegate = self
        urlTextField.delegate = self
        
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .primaryActionTriggered)
        
        downloaderBox.widthAnchor.constraint(equalToConstant: 474).isActive = true
        downloaderBox.heightAnchor.constraint(equalToConstant: 618).isActive = true
        downloaderBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        downloaderBox.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: downloaderBox.topAnchor, constant: 97).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 360).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        separatorYellow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        separatorYellow.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        separatorYellow.widthAnchor.constraint(equalToConstant: 310).isActive = true
        separatorYellow.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: separatorYellow.bottomAnchor, constant: 45).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 360).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        textFieldNameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5).isActive = true
        textFieldNameLabel.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        textFieldNameLabel.widthAnchor.constraint(equalToConstant: 360).isActive = true
        textFieldNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        urlTextField.topAnchor.constraint(equalTo: textFieldNameLabel.bottomAnchor, constant: 25).isActive = true
        urlTextField.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        urlTextField.widthAnchor.constraint(equalToConstant: 360).isActive = true
        urlTextField.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        textFieldURLLabel.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 5).isActive = true
        textFieldURLLabel.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        textFieldURLLabel.widthAnchor.constraint(equalToConstant: 360).isActive = true
        textFieldURLLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: textFieldURLLabel.bottomAnchor, constant: 25).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: downloaderBox.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        print("\n\n  Loader View Controller")
    }
    
    func setPopupPresentation() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    @objc private func saveButtonPressed() {
        
        guard let name = nameTextField.text, let urlString = urlTextField.text else { return }
        Spinner.show(in: self.view, title: "Идет загрузка", backgroundAlpha: 0.8, isUserInteractionEnabled: false)
        DownloadHandler.download(name: name, urlString: urlString) { (message, failure) in
            DispatchQueue.main.async {
                if !failure {
                    print("\n\n  Success: \(message)")
                    
                } else {
                    print("\n\n Failure: \(message)")
                }
                
                self.dismiss(animated: true, completion: {
                    print("\n\n LoaderViewController is dismissed")
                })
            }
        }
    }
}

extension LoaderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        let url = urlTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if name?.count != 0, url?.count != 0 {
            saveButton.layer.backgroundColor = UIColor(hexString: "#3FDE10").cgColor
            saveButton.isEnabled = true
            
        } else {
            saveButton.layer.backgroundColor = UIColor(hexString: "#3E4157").cgColor
            saveButton.isEnabled = false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 15
        } else {
            return true
        }
    }
}
