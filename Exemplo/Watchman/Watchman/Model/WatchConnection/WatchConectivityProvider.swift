//
//  WatchConectivityProvider.swift
//  Watchman
//
//  Created by Pedro Henrique on 02/12/21.
//

import WatchConnectivity
import UIKit

class WatchConnectivityProvider: NSObject {
    
    private let session: WCSession
    
    var onUserSelected: ((_: User?) -> Void)?
    
    
    init(_ session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        connect()
    }
    
    private func connect() {
        guard WCSession.isSupported() else { return }
        session.activate()
    }
    
    func send(data: Data) {
        session.sendMessageData(data, replyHandler: nil) { error in
            debugPrint(error.localizedDescription)
        }
    }
    
}

extension WatchConnectivityProvider: WCSessionDelegate {
    
    #if os(iOS)
        func sessionDidBecomeInactive(_ session: WCSession) {
            // fazer algo... ou não
        }
        
        func sessionDidDeactivate(_ session: WCSession) {
            // fazer algo... ou não
        }
    #endif
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint(activationState)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        if let selectedUser = try? JSONDecoder().decode(User.self, from: messageData) {
            onUserSelected?(selectedUser)
        }
        
    }
    
    
}
