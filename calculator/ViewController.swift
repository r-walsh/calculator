 //
//  ViewController.swift
//  calculator
//
//  Created by Ryan Walsh on 5/11/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    var buttonSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    // Initial State
    var runningNumber = ""
    var leftVal = ""
    var rightVal = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func processOperation( operation: Operation ) {
        playSound()
        
        if currentOperation != Operation.Empty {
            if runningNumber != "" {
                rightVal = runningNumber
                runningNumber = ""
                
                switch currentOperation {
                    case Operation.Divide:
                        result = "\(Double( leftVal )! / Double( rightVal )!)"
                        break
                    case Operation.Multiply:
                        result = "\(Double( leftVal )! * Double( rightVal )!)"
                        break
                    case Operation.Subtract:
                        result = "\(Double( leftVal )! - Double( rightVal )!)"
                        break
                    case Operation.Add:
                        result = "\(Double( leftVal )! + Double( rightVal )!)"
                        break
                    default:
                        break
                }
                leftVal = result
                outputLabel.text = result
            }
            
            currentOperation = operation
            
        } else {
            leftVal = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func playSound() {
        if buttonSound.playing {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
    // MARK Actions
    
    @IBAction func numberPressed( button: UIButton ) {
        playSound()
        
        runningNumber += "\( button.tag )"
        outputLabel.text = runningNumber
    }
    
    @IBAction func dividePressed( button: UIButton ) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func multiplyPressed( button: UIButton ) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func subtractPressed( button: UIButton ) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func addPressed( button: UIButton ) {
        processOperation(Operation.Add)
    }
    
    @IBAction func equalPressed( button: UIButton ) {
        processOperation(currentOperation)
    }
    
    @IBAction func clearPressed( button: UIButton ) {
        runningNumber = ""
        leftVal = ""
        rightVal = ""
        currentOperation = Operation.Empty
        result = ""
        outputLabel.text = "0"
    }

}

