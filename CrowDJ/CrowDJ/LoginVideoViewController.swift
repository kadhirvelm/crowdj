//
//  LoginVideoViewController.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/10/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import UIKit
import MediaPlayer

class LoginVideoViewController: UIViewController {

    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override func viewDidLoad() {
        let theURL = NSBundle.mainBundle().URLForResource("LED_Video", withExtension: "mp4")
        avPlayer = AVPlayer(URL: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clearColor();
        view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVideoViewController.playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seekToTime(kCMTimeZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        avPlayer.play()
        paused = false
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        avPlayer.pause()
        paused = true
        
    }
}
