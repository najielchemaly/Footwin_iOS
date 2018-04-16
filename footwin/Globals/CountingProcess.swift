//
//  CountingProcess.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/16/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

class CountingProcess {
    
    let minValue: Int
    let maxValue: Int
    var currentValue: Int
    
    private let progressQueue = DispatchQueue(label: "ProgressView")
    private let semaphore = DispatchSemaphore(value: 1)
    
    init (minValue: Int, maxValue: Int) {
        self.minValue = minValue
        self.currentValue = minValue
        self.maxValue = maxValue
    }
    
    private func delay(stepDelayUsec: useconds_t, completion: @escaping ()->()) {
        usleep(stepDelayUsec)
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func simulateLoading(toValue: Int, step: Int = 1, stepDelayUsec: useconds_t? = 2_000,
                         valueChanged: @escaping (_ currentValue: Int)->(),
                         completion: ((_ currentValue: Int)->())? = nil) {
        
        semaphore.wait()
        progressQueue.sync {
            if currentValue <= toValue && currentValue <= maxValue {
                usleep(stepDelayUsec!)
                DispatchQueue.main.async {
                    valueChanged(self.currentValue)
                    self.currentValue += step
                    self.semaphore.signal()
                    self.simulateLoading(toValue: toValue, step: step, stepDelayUsec: stepDelayUsec, valueChanged: valueChanged, completion: completion)
                }
                
            } else {
                self.semaphore.signal()
                completion?(currentValue)
            }
        }
    }
    
    func finish(step: Int = 1, stepDelayUsec: useconds_t? = 10_000,
                valueChanged: @escaping (_ currentValue: Int)->(),
                completion: ((_ currentValue: Int)->())? = nil) {
        simulateLoading(toValue: maxValue, step: step, stepDelayUsec: stepDelayUsec, valueChanged: valueChanged, completion: completion)
    }
}
