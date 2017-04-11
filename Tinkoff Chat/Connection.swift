//
//  Connection.swift
//  Tinkoff Chat
//
//  Created by Admin on 05.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ConnectionToYou: NSObject {
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.PeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    private let serviceType = "tinkoff-chat"

    private let PeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    
    private let myDiscoveryInfo = ["userName": "MaximDanko"]
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: PeerId, discoveryInfo: myDiscoveryInfo, serviceType: serviceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
}


extension ConnectionToYou : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)

    }
}


extension ConnectionToYou : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")

    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
}

