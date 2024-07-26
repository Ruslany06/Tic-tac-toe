//
//  ViewController.swift
//  Tic tac toe
//
//  Created by Ruslan Yelguldinov on 15.06.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        setTagsOnButtons()
    }
    
    var player = 1
    var counter = 0
    var btnState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var winCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    let fieldImageView = {
        let iv = UIImageView()
        
        iv.image = UIImage.ticTacToeField
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 1
        iv.backgroundColor = .cyan
        
        return iv
    }()
    
    lazy var buttonsArray: [UIButton] = (0..<9).map { button in
        let button = UIButton()
        return button
    }
    
    // MARK: Actions
    @objc func buttonTapped(sender: UIButton) {
        print("Button \(sender.tag) tapped")
        
        if btnState[sender.tag - 1] != 0 {
            return
        }
        
        counter += 1
        
        if player == 1 {
            sender.setImage(UIImage.cross, for: .normal)
            btnState[sender.tag - 1] = 1
            player = 2
        } else {
            sender.setImage(UIImage.nought, for: .normal)
            btnState[sender.tag - 1] = 2
            player = 1
        }
        for winArray in winCombinations {
            if btnState[winArray[0]] == 1 && btnState[winArray[1]] == 1 && btnState[winArray[2]] == 1 {
                
                let alert = UIAlertController(title: "Cross wins!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {
                    UIAlertAction in
                    self.clear()
                }))
                present(alert, animated: true)
                return
            }
            if btnState[winArray[0]] == 2 && btnState[winArray[1]] == 2 && btnState[winArray[2]] == 2 {
                
                let alert = UIAlertController(title: "Nought wins!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                    self.clear()
                }))
                present(alert, animated: true)
                return
            }
        }
        if counter == 9 {
            let alert = UIAlertController(title: "Draw game!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                self.clear()
            }))
            present(alert, animated: true)
        }
    }
    func setTagsOnButtons() {
        // Version 1
        var tag = 1
        for btn in buttonsArray {
            btn.tag = tag
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            tag += 1
        }
        // Version 2
//        buttonsArray.enumerated().forEach { index, button in
//            button.tag = index
//            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        }
    }
    
    func clear() {
        player = 1
        counter = 0
        
        for i in 0...8 {
            btnState[i] = 0
            let button = view.viewWithTag(i + 1) as! UIButton
            
            button.setImage(nil, for: .normal)
        }
        
    }
    
    // MARK: Constraints
    func setupConstraints() {
        view.addSubview(fieldImageView)
        
        fieldImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(400)
        }
        buttonsArray.forEach { button in
            view.addSubview(button)
        }

        let buttonSize = 119
        let spacing = 11
        
        // Размещаем кнопки
        for rows in 0..<3 {
            for columns in 0..<3 {
                let index = rows * 3 + columns
                
                buttonsArray[index].snp.makeConstraints { make in
                    // Верхняя кнопка, если это первая строка
                    if rows == 0 {
                        make.top.equalTo(fieldImageView.snp.top).offset(spacing)
                    } else {
                        // Все остальные строки привязываем к нижней границе кнопки в предыдущей строке
                        make.top.equalTo(buttonsArray[index - 3].snp.bottom).offset(spacing)
                    }
                    
                    // Левая кнопка, если это первый столбец
                    if columns == 0 {
                        make.leading.equalTo(fieldImageView.snp.leading).offset(spacing)
                    } else {
                        // Все остальные столбцы привязываем к правой границе кнопки в предыдущем столбце
                        make.leading.equalTo(buttonsArray[index - 1].snp.trailing).offset(spacing)
                    }
                    // Устанавливаем размер кнопки
                    make.size.equalTo(buttonSize)
                }
            }
        }

            
    }
    
    
    
}

