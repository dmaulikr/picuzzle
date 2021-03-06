//
//  LoadingScreenViewController.swift
//  picuzzle
//
//  Created by Jesper Johnsson on 2016-11-28.
//  Copyright © 2016 Jesper Johnsson. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LoadingScreenViewController: UIViewController,MCSessionDelegate,MCBrowserViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @IBOutlet weak var connectelr: UITextField!
    @IBOutlet weak var skickaTxt: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var connectionState: UILabel!
    

    @IBAction func sendMessage(_ sender: Any) {
        self.sendMessages(message: "Hej")
    }
    
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden=false
        // Do any additional setup after loading the view, typically from a nib.
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self
        title = "Connect"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(LoadingScreenViewController.showConnectionPrompt))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            self.connectionState.text = "Connected"
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            self.connectionState.text = "Connecting"
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            self.connectionState.text = "Not connected"
            
        }
    }
    func sendText(String: String) {
        if mcSession.connectedPeers.count > 0 {
            connectelr.text = "Skickade over"
            print("Funkar fan")
            
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        //let dictionary: [String: AnyObject] = ["data": data as AnyObject, "fromPeer": peerID]
        
        let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        print(dictionary)
        
        print(dictionary)
        if (data != nil) {
            DispatchQueue.main.async { [unowned self] in
                // do something with the image
                print(data)
            }
        }
        
    }
    
    func sendMessages(message: String) {
        print("INSIDE MESSAGE FUNCTION")
        print(mcSession.connectedPeers.count)
        var hej = NSArray(objects: "Time Attack", "Time Trial", "Multiplayer")
       
        var dictionaryExample : [String:AnyObject] = ["user":"UserName" as AnyObject, "pass":"password" as AnyObject, "token":"0123456789" as AnyObject, "image":0 as AnyObject]
        
        let dataExample: Data = NSKeyedArchiver.archivedData(withRootObject: dictionaryExample)
        //let dictionary: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: dataExample) as! [String : Any]
        
        
        
        if mcSession.connectedPeers.count > 0 {
           
            //let json = try? JSONSerialization.data(withJSONObject: message, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            do {
                try mcSession.send(dataExample, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
 
    }
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "Connection", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "Connection", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    func showConnectionPrompt(){
        let ac = UIAlertController(title: "Connect to athoers", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session",style: .default,handler:startHosting))
        ac.addAction(UIAlertAction(title: "Join a session",style: .default,handler:joinSession))
        ac.addAction(UIAlertAction(title: "Cancel",style: .cancel, handler:nil))
        present(ac,animated:true,completion: nil)
    }
    
}
