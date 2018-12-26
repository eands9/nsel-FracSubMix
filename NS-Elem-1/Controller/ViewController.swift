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
    @IBOutlet weak var numDLbl: UILabel!
    @IBOutlet weak var numELbl: UILabel!
    @IBOutlet weak var numFLbl: UITextField!
    
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var timer = Timer()
    var counter = 0.0
    
    var randomNumA : Int = 0
    var randomDenA : Int = 0
    var randomNumB : Int = 0
    var randomDenB : Int = 0
    
    var numA : Int = 0
    var denA : Int = 0
    var numB : Int = 0
    var denB : Int = 0
    var numC : Int = 0
    var denC : Int = 0
    
    var questionTxt : String = ""
    var answerCorrect : Double = 0
    var answerCorrectSimplify : Double = 0
    var answerUserNum : Double = 0
    var answerUserDen : Double = 0
    var answerUser : Double = 0
    var isShow: Bool = false
    
    var randomAWholeD : Int = 0
    var randomBWholeE : Int = 0
    var answerUserWholeF : Double = 0
    var numD = 0
    var numE = 0
    var numF = 0
    var numDTxt = ""
    var denETxt = ""
    var randomIndex = 0
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        askQuestion()
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        self.numFLbl.becomeFirstResponder()
    }

    @IBAction func checkAnswerByUser(_ sender: Any) {
        checkAnswer()
    }
    @IBAction func showBtn(_ sender: Any) {
        numCTxt.text = String(numC)
        denCTxt.text = String(denC)
        numFLbl.text = String(numF)
        numberAttempts += 1
        updateProgress()
        isShow = true
    }
    func askQuestion(){
        
        numALbl.text = String(numA)
        denALbl.text = String(denA)
        numBLbl.text = String(numB)
        denBLbl.text = String(denB)
        numCTxt.text = ""
        denCTxt.text = ""
        
        randomAWholeD = Int.random(in: 1...5)
        randomBWholeE = Int.random(in: 1...5)
        
        randomIndex = Int.random(in: 0...2)
        switch randomIndex{
        case 0: //Generate only whole number for Frac A
            numD = randomAWholeD
         case 1: //Generate only whole number for Frac B
            numE = randomBWholeE
        case 2:
            numD = randomAWholeD
            numE = randomBWholeE
        default:
            numD = 999
            numE = 999
        }
        getAFraction()
        getBFraction()
        getSimplifiedAnswer()
        
        numALbl.text = String(numA)
        denALbl.text = String(denA)
        numBLbl.text = String(numB)
        denBLbl.text = String(denB)
        numDLbl.text = String(numD)
        numELbl.text = String(numE)
        numCTxt.text = ""
        denCTxt.text = ""
        numFLbl.text = ""
        
        if Int(numDLbl.text!)! < 1{
            numDLbl.text = ""
        }
        if Int(numELbl.text!)! < 1{
            numELbl.text = ""
        }
        self.numFLbl.becomeFirstResponder()
    }
    
    func checkAnswer(){
        getSimplifiedAnswer()
        
        answerUserNum = (numCTxt.text! as NSString).doubleValue
        answerUserDen = (denCTxt.text! as NSString).doubleValue
        answerUserWholeF = (numFLbl.text! as NSString).doubleValue
        answerUser = answerUserWholeF + (answerUserNum / answerUserDen)
        
        if numCTxt.text == "" || denCTxt.text == ""{
            randomTryAgain()
        }
        else {
            if numC == Int(answerUserNum) && denC == Int(answerUserDen) && numF == Int(answerUserWholeF) {
                if isShow == false{
                    correctAnswers += 1
                    numberAttempts += 1
                    updateProgress()
                    randomPositiveFeedback()
                }
                else{
                    numberAttempts += 1
                    updateProgress()
                    readMe(myText: "Next Question!")
                    isShow = false
                }
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    //next problem
                    self.askQuestion()
                    self.numCTxt.text = ""
                    self.denCTxt.text = ""
                    self.numFLbl.text = ""
                }
            }
            else{
                randomTryAgain()
                numCTxt.text = ""
                denCTxt.text = ""
                numberAttempts += 1
                updateProgress()
            }
        }
    }
    
    typealias Rational = (num : Int, den : Int)
    func simplifyFrac(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    func getSimplifiedAnswer(){
        switch randomIndex{ //0 = Only Frac B is mixed frac; 1 = Only Frac A is mixed; 2 = both are mixed)
        case 0://adding whole numD ONLY
            answerCorrect = Double(numD) + (Double(numA)/Double(denA)) + (Double(numB)/Double(denB))
        case 1://adding whole numE ONLY
            answerCorrect = Double(numE) + (Double(numA)/Double(denA)) + (Double(numB)/Double(denB))
        case 2://adding both whole D & E
            answerCorrect = Double(numD) + Double(numE) + (Double(numA)/Double(denA)) + (Double(numB)/Double(denB))
        default:
            answerCorrect = 9.99
        }
        //answerCorrect = (Double(numA)/Double(denA)) + (Double(numB)/Double(denB))
        
        let d = answerCorrect
        let (wholePart, fractionalPart) = modf(d)
        numF = (Int(wholePart))
        
        let answerCorrectSimplify = simplifyFrac(x0: fractionalPart)
        numC = answerCorrectSimplify.num
        denC = answerCorrectSimplify.den
        
        print("simplified numF is \(numF)")
        print("answerCorrect is \(answerCorrect)")
    }
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    func getAFraction(){
        randomNumA = Int.random(in: 1 ..< 5)
        randomDenA = Int.random(in: 1 ..< 5)
        
        //divide numerator by 2 to make sure the numerator is as small as possible
        // + 1 is to make sure we don't have a zero numerator
        if randomNumA < randomDenA {
            numA = randomNumA/2 + 1
            denA = randomDenA
        }
        else {
            numA = randomDenA/2 + 1
            denA = randomNumA
        }
        if numA == denA {
            denA += 1
        }
    }
    func getBFraction(){
        randomNumB = Int.random(in: 1 ..< 5)
        randomDenB = Int.random(in: 1 ..< 5)
        
        if randomNumB < randomDenB {
            numB = randomNumB/2 + 1
            denB = randomDenB
        }
        else {
            numB = randomDenB/2 + 1
            denB = randomNumB
        }
        if numB == denB{
            denB += 1
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

