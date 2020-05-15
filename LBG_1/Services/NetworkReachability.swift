//
//  NetworkReachability.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation
import SystemConfiguration


let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"

enum InternetReachabilityStatus {
	case notReachable
	case reachableViaWiFi
	case reachableViaWWAN
}


class InternetReachability: NSObject {
	private var networkReachability: SCNetworkReachability?
	private var notifying: Bool = false
	
	private var flags: SCNetworkReachabilityFlags {
		
		var flags = SCNetworkReachabilityFlags(rawValue: 0)
		
		if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0)) }) == true {
			return flags
		}
		else {
			return []// Returning Empty Set
		}
	}

	var currentReachabilityStatus: InternetReachabilityStatus {
		
		if flags.contains(.reachable) == false {
			// The target host is not reachable.
			return .notReachable
		}
		else if flags.contains(.isWWAN) == true {
			// WWAN connections are OK if the calling application is using the CFNetwork APIs.
			return .reachableViaWWAN
		}
		else if flags.contains(.connectionRequired) == false {
			// If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
			return .reachableViaWiFi
		}
		else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
			// The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
			return .reachableViaWiFi
		}
		else {
			return .notReachable
		}
	}

	var isReachable: Bool {
		switch currentReachabilityStatus {
			case .notReachable:
				return false
			case .reachableViaWiFi, .reachableViaWWAN:
				return true
		}
	}

	init?(hostName: String) {
		networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostName as NSString).utf8String!)
		super.init()
		if networkReachability == nil {
			return nil
		}
	}
	
	init?(hostAddress: sockaddr_in) {
		var address = hostAddress
		
		guard let defaultRouteReachability = withUnsafePointer(to: &address, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
			}
		}) else {
			return nil
		}
		
		networkReachability = defaultRouteReachability
		
		super.init()
		if networkReachability == nil {
			return nil
		}
	}

	
	static func networkReachabilityForInternetConnection() -> InternetReachability? {
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		return InternetReachability(hostAddress: zeroAddress)
	}
	
	static func networkReachabilityForLocalWiFi() -> InternetReachability? {
		var localWifiAddress = sockaddr_in()
		localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
		localWifiAddress.sin_family = sa_family_t(AF_INET)
		// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0 (0xA9FE0000).
		localWifiAddress.sin_addr.s_addr = 0xA9FE0000
		
		return InternetReachability(hostAddress: localWifiAddress)
	}

	func startNotifier() -> Bool {
		
		guard notifying == false else {
			return false
		}
		
		var context = SCNetworkReachabilityContext()
		context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
		
		guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
			if let currentInfo = info {
				let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
				if infoObject is InternetReachability {
					let networkReachability = infoObject as! InternetReachability
					NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: networkReachability)
				}
			}
		}, &context) == true else { return false }
		
		guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
		
		notifying = true
		return notifying
	}

	func stopNotifier() {
		if let reachability = networkReachability, notifying == true {
			SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
			notifying = false
		}
	}

	deinit {
		stopNotifier()
	}

}


// MARK:- Notes for usage
/**
To register & unregister VC to receive notifications
=================================================================================
inside VC - ViewdidLoad/Appear
=============================
NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)

_ = reachability?.startNotifier()

=================================================================================
inside VC - deinit/DisAppear
=============================
NotificationCenter.default.removeObserver(self)
reachability?.stopNotifier()

=================================================================================

*/

