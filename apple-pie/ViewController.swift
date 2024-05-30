//
//  ViewController.swift
//  apple-pie
//
//  Created by Ueta, Lucas T on 11/7/23.
//

import UIKit

class ViewController: UIViewController {
    let treeImageView = UIImageView(),
        scoreLabel = UILabel(),
        correctWordLabel = UILabel(),
        bottomHalf = UIStackView(),
        incorrectMovesAllowed = 7
    
    var keys: [Character: UIButton] = [:],
        listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"],
        currectGame: Game!
    
    var totalWins = 0 {
        didSet { newRound() }
    }
    var totalLosses = 0 {
        didSet { newRound() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // stack
        let stack = UIStackView()
        stack.axis = .vertical
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
        
        // tree
        treeImageView.image = UIImage(named: "Tree 0.pdf")
        treeImageView.contentMode = .scaleAspectFit
        
        treeImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(treeImageView)
        
        // bottom half of the screen
        bottomHalf.axis = .vertical
        bottomHalf.alignment = .center
        bottomHalf.distribution = .fillEqually
        bottomHalf.spacing = 5
        
        bottomHalf.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(bottomHalf)
        
        addKeyboardRow("qwertyuiop", to: bottomHalf)
        addKeyboardRow("asdfghjkl", to: bottomHalf)
        addKeyboardRow("zxcvbnm", to: bottomHalf)
        
        // correct word label
        correctWordLabel.text = "Label"
        correctWordLabel.font = UIFont.systemFont(ofSize: 30)
        
        bottomHalf.addArrangedSubview(correctWordLabel)
        
        // score label
        scoreLabel.text = "Label"
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        
        bottomHalf.addArrangedSubview(scoreLabel)
        
        // game
        newRound()
    }

    func addKeyboardRow(_ letters: String, to keyboard: UIStackView) {
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 5
        
        for letter in Array(letters.uppercased()) { addKey(letter, to: row) }
        keyboard.addArrangedSubview(row)
    }
    
    func addKey(_ letter: Character, to row: UIStackView) {
        let key = UIButton()
        key.setTitle(String(letter), for: .normal)
        key.titleLabel!.font = UIFont.systemFont(ofSize: 30)
        key.setTitleColor(.systemBlue, for: .normal)
        key.setTitleColor(.systemGray, for: .disabled)
        key.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        
        key.translatesAutoresizingMaskIntoConstraints = false
        row.addArrangedSubview(key)
        NSLayoutConstraint.activate([
            key.heightAnchor.constraint(equalToConstant: 36),
            key.widthAnchor.constraint(equalTo: key.heightAnchor)
        ])
        
        keys[letter] = key
    }
    
    @objc func keyPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currectGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currectGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableKeys(true)
            updateUI()
        }
        else { enableKeys(false) }
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currectGame.formattedWord { letters.append(String(letter)) }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currectGame.incorrectMovesRemaining)")
    }
    
    func updateGameState() {
        if currectGame.incorrectMovesRemaining == 0 { totalLosses += 1 }
        else if currectGame.word == currectGame.formattedWord { totalWins += 1 }
        else { updateUI() }
    }
    
    func enableKeys(_ enable: Bool) { for key in keys.values { key.isEnabled = enable }}
}

