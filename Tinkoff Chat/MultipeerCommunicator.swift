//
//  MultipeerCommunicator.swift
//  Tinkoff Chat
//
//  Created by Admin on 08.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    weak var delegate: CommunicatorDelegate?
    
    var online: Bool = true
    
    private let _serviceAdvertiser : MCNearbyServiceAdvertiser
    private let _serviceBrowsing: MCNearbyServiceBrowser
    private let _serviceType = "tinkoff-chat"
    private var _discoveryInfo = [String:String]()
    private var _sessions = [String:MCSession]()
    private let _peerID = MCPeerID(displayName: (UIDevice.current.identifierForVendor?.uuidString)!)
    
    private var defaultNames = [String:String]()
    
    private static let multipeerCommunicator = MultipeerCommunicator()
    
    static func getInstance() -> MultipeerCommunicator {
        return multipeerCommunicator
    }
    
    private override init() {
        self._discoveryInfo["userName"] = "DarkSideMaxim"
        
        self._serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self._peerID, discoveryInfo: nil, serviceType: self._serviceType)
        self._serviceBrowsing = MCNearbyServiceBrowser(peer: self._peerID, serviceType: self._serviceType)
        
        super.init()
        
        self._serviceAdvertiser.delegate = self
        self._serviceAdvertiser.startAdvertisingPeer()
        
        self._serviceBrowsing.delegate = self
        self._serviceBrowsing.startBrowsingForPeers()
    }
    
    deinit {
        self._serviceAdvertiser.stopAdvertisingPeer()
        self._serviceBrowsing.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let session = self.getSessionBy(peerDisplayName: userID)
        let message = ["eventType": "TextMessage", "messageId": _generateMessageId(), "text": string]
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            if let completion = completionHandler {
                completion(true,nil)
            }
        } catch let error {
            if let completion = completionHandler {
                completion(false,error)
            }
        }
    }
    
    func getSessionBy(peerDisplayName: String) -> MCSession {
        if let session = self._sessions[peerDisplayName] {
            return session
        } else {
            let session = MCSession(peer: self._peerID, securityIdentity: nil, encryptionPreference: .none)
            session.delegate = self
            self._sessions[peerDisplayName] = session
            return session
        }
    }
    
    private func _generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    //>>>>>>>>>>>>>>>>>> Обработка ошибок <<<<<<<<<<<<<<<<<<<<<<<//
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    //<<<<<<<<<<<<<<<<<<<<<< Конец обработки ошибок >>>>>>>>>>>>>>//
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let session = getSessionBy(peerDisplayName: peerID.displayName)
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        var defaultName = "Unknowed"
        if let userName = info?["userName"] {
            defaultName = userName
        }
        self.defaultNames[peerID.displayName] = defaultName
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let session = getSessionBy(peerDisplayName: peerID.displayName)
        invitationHandler(true, session)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            delegate?.didFoundUser(userID: peerID.displayName, userName: defaultNames[peerID.displayName])
        case MCSessionState.notConnected:
            delegate?.didLostUser(userID: peerID.displayName)
        default: break
            
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        var dictionary = [String: String]()
        
        do {
            dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
        } catch let error {
            print(error.localizedDescription)
        }
        if let text = dictionary["text"] {
            print(peerID.displayName)
            delegate?.didReceiveMessage(text: text, fromUser: peerID.displayName, toUser: self._peerID.displayName)
        }
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    //*************************** Unusing methonds ************************************** //
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
    
}
