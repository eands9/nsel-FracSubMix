//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!

    
    @IBOutlet weak var numALbl: UILabel!
    @IBOutlet weak var denALbl: UILabel!
    @IBOutlet weak var numBLbl: UILabel!
    @IBOutlet weak var denBLbl: UILabel!
    @IBOutlet weak var numCTxt: UITextField!
    @IBOutlet weak var denCTxt: UITextField!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0
    
    var randomNumA : Int = 0
    var randomDenA : Int = 0
    var randomNumB : Int = 0
    var randomDenB : Int = 0
    var randomNumC : Int = 0
    var randomDenC : Int = 0
    
    var numA : Int = 0
    var denA : Int = 0
    var numB : Int = 0
    var denB : Int = 0
    var numC : Int = 0
    var denC : Int = 0
    
    var questionTxt : String = ""
    var answerCorrect : Int = 0
    var answerUserNum : Int = 0
    var answerUserDen : Int = 0
    var answerUser : Int = 0
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.numCTxt.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    
    func askQuestion(){
        getAFraction()
        getBFraction()
        
        numALbl.text = String(numA)
        denALbl.text = String(denA)
        numBLbl.text = String(numB)
        denBLbl.text = String(denB)
    }
    
    func checkAnswer(){
        
        answerUserNum = (numCTxt.text! as NSString).integerValue
        answerUserDen = (denCTxt.text! as NSString).integerValue
        answerUserNum = answerUserNum / answerUserDen
        
        
        answerCorrect = (numA/denA) + (numB/denB)
        
        if answerCorrect == answerUser {
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            randomPositiveFeedback()
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                //next problem
                self.askQuestion()
                self.numCTxt.text = ""
                self.denCTxt.text = ""
            }
        }
        else{
            randomTryAgain()
            numCTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
    
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func getAFraction(){
        randomNumA = Int.random(in: 1 ..< 13)
        randomDenA = Int.random(in: 1 ..< 13)
        
        if randomNumA < randomDenA {
            numA = randomNumA
            denA = randomDenA
        }
        else {
            numA = randomDenA
            denA = randomNumA
        }
    }
    func getBFraction(){
        randomNumB = Int.random(in: 1 ..< 13)
        randomDenB = Int.random(in: 1 ..< 13)
        
        if randomNumB < randomDenB {
            numB = randomNumB
            denB = randomDenB
        }
        else {
            numB = randomDenB
            denB = randomNumB
        }
    }

    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
    }
    
    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
    
    func randomTryAgain(){
        randomPick = Int(arc4random_uniform(2))
        readMe(myText: retryArray[randomPick])
    }
}

