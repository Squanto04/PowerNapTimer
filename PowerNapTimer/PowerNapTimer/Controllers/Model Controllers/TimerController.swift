//
//  TimerController.swift
//  PowerNapTimer
//
//  Created by Jordan Lamb on 9/24/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

protocol TimerDelegate: class {
    func timerSecTicked()
    func timerCompleted()
    func timerStopped()
}

class TimerController {
    
    //Source of Truth - Built in classes
    var timer: Timer?
    var timeRemaining: TimeInterval?
    
    weak var delegate: TimerDelegate?
    
    var isOn: Bool {
            return timeRemaining != nil ? true : false
        }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else {return}
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecTicked()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.timerCompleted()
        }
    }
    
    func startTimer(_ time: TimeInterval) {
        if isOn == false {
            timeRemaining = time
            DispatchQueue.main.async {
//                secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn == true {
            timeRemaining = nil
            timer?.invalidate()
            delegate?.timerStopped()
        }
    }
} // End of Class
