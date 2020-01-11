//
//  ReachabilityHandler.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import SystemConfiguration
import CoreTelephony

class ReachabilityHandler: ReachabilityHandlerProtocol {
    var onListenerNotified: ((NetworkStatus) -> ())?
    
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    private var currentReachabilityFlags: SCNetworkReachabilityFlags?
    private var isListening = false
    
    func handle(with reachabilityOption: ReachabilityHandlerOption) {
        switch reachabilityOption {
        case .startListening:
            startListening()
        case .stopListening:
            stopListening()
        }
    }
    
    private func startListening() {
        if isListening { return }
        
        guard let reachability = reachability else { return }
        
        isListening = true

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)

        context.info = UnsafeMutableRawPointer(Unmanaged<ReachabilityHandler>.passUnretained(self).toOpaque())
        
        //this is called when network status changes
        let callback: SCNetworkReachabilityCallBack? = { reachability, flags, info in
            guard let info = info else { return }
            
            let manager = Unmanaged<ReachabilityHandler>.fromOpaque(info).takeUnretainedValue()
            
            DispatchQueue.main.async {
                manager.checkReachability(flags: flags)
            }
        }
        
        if !SCNetworkReachabilitySetCallback(reachability, callback, &context) {
            //callback not set
        }
        
        if !SCNetworkReachabilitySetDispatchQueue(reachability, DispatchQueue.main) {
            //queue not set
        }
        
        DispatchQueue.main.async {
            // Resets the flags stored, in this way `checkReachability` will set the new ones
            self.currentReachabilityFlags = nil
            
            // Reads the new flags
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
            
            self.checkReachability(flags: flags)
        }
    }
    
    private func checkReachability(flags: SCNetworkReachabilityFlags) {
        if currentReachabilityFlags != flags {
            
            notifyListener(flags: flags)
            
            currentReachabilityFlags = flags
        }
    }
    
    private func notifyListener(flags: SCNetworkReachabilityFlags) {
        guard let onListenerNotified = onListenerNotified else {
            return
        }
        
        let networkStatus: NetworkStatus = networkReachabilityStatusForFlags(flags)
        
        onListenerNotified(networkStatus)
    }
    
    // Stops listening
    private func stopListening() {
        guard isListening, let reachability = reachability else { return }
        
        // Remove callback and dispatch queue
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        
        isListening = false
    }
    
    private func networkReachabilityStatusForFlags(_ flags: SCNetworkReachabilityFlags) -> NetworkStatus {
        if !isNetworkReachable(with: flags) {
            return .notReachable
        }
        
        if flags.contains(.isWWAN) {
            return .reachable(.cellular(cellularConnectionType()))
        }
        
        return .reachable(.wifi)
    }
    
    private func cellularConnectionType() -> CellularConnectionType {
        let networkInfo = CTTelephonyNetworkInfo()
        guard let carrierType = networkInfo.serviceCurrentRadioAccessTechnology else {
            return .notDetermined
        }
        
        if (carrierType[CTRadioAccessTechnologyGPRS] != nil ||
            carrierType[CTRadioAccessTechnologyEdge] != nil ||
            carrierType[CTRadioAccessTechnologyCDMA1x] != nil) {
            return .GPRS
        }
        
        if (carrierType[CTRadioAccessTechnologyWCDMA] != nil ||
            carrierType[CTRadioAccessTechnologyHSDPA] != nil ||
            carrierType[CTRadioAccessTechnologyCDMAEVDORev0] != nil ||
            carrierType[CTRadioAccessTechnologyCDMAEVDORevA] != nil ||
            carrierType[CTRadioAccessTechnologyCDMAEVDORevB] != nil ||
            carrierType[CTRadioAccessTechnologyHSUPA] != nil) {
            return .CDMA
        }
    
        if (carrierType[CTRadioAccessTechnologyLTE] != nil) {
            return .LTE
        }
        
        return .notDetermined
    }
    
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    deinit {
        stopListening()
    }
}

