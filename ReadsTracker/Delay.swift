//
//  Delay.swift
//  BookTracker
//
//  Created by Daniel McAteer on 12/29/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

func delayOnMainThread(seconds: Double, action:(() -> ())!) {
    
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64( seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
        action()
    })
    
    let queue = DispatchQueue(label: "com.test.myqueue")
    queue.async {}
}
