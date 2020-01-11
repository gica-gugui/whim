//
//  InfraUtils.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import RxSwift

public struct InfraHelper {
    public static var backgroundWorkScheduler: SerialDispatchQueueScheduler = {
        var queue = DispatchQueue.global(qos: .userInitiated)
        
        return SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: "AppBackgroundQueue")
    }()
    
    public static func printTimeElapsedWhenRunningCode(title: String, operation: () -> ()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s")
    }
}
