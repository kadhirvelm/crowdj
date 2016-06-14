//
//  QueueViewController.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import CoreData

class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var refreshControl = UIRefreshControl()
    var player = AVAudioPlayer()
    var queued_songs: [Music_queue]?
    let crowdCoreDate = crowdjCoreData()
    var currently_playing = false
    
    
    @IBOutlet weak var queueTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(QueueViewController.updateTables), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.queueTable.addSubview(self.refreshControl)
    }
    
    func updateTables() {
        refreshControl.beginRefreshing()
        queued_songs = crowdCoreDate.retrieveData("Music_queue") as? [Music_queue]
        if ((queued_songs?.count > 0) && (currently_playing == false)){
            currently_playing = true
            play_first_in_stack()
        } else if ((queued_songs?.count == 0) && (currently_playing == true)) {
            currently_playing = false
        }
        queueTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    func play_first_in_stack() {
        let top_song = queued_songs![0]
        queued_songs?.removeAtIndex(0)
        crowdCoreDate.deleteFirstEntry("Music_queue")
        playMusic((top_song.url?.integerValue)!, title: top_song.title!, artist: top_song.artist!, playback: top_song.playback!, artwork: top_song.artwork!, genre: top_song.genre!)
    }
    
    @IBAction func clearQueue(sender: UIButton) {
        crowdCoreDate.deleteAllData("Music_queue")
        updateTables()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateTables()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    func playMusic(asset_url: Int, title: String, artist: String, playback: String, artwork: NSData, genre: String) {
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            let all_music_items = MPMediaQuery.songsQuery().items!
            let url = all_music_items[asset_url].assetURL
            player = try AVAudioPlayer(contentsOfURL: url!)
            player.play()
            
            let image = UIImage(data: artwork)
            let artwork_image = MPMediaItemArtwork(image: image!)
            
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
                MPMediaItemPropertyTitle: title,
                MPMediaItemPropertyArtist: artist,
                MPMediaItemPropertyPlaybackDuration: playback,
                MPMediaItemPropertyArtwork: artwork_image,
                MPMediaItemPropertyGenre: genre]
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        switch (event!.subtype){
        case UIEventSubtype.RemoteControlPause:
            self.tabBarItem.selectedImage = UIImage(named: "Pause Filled-50")!
            self.tabBarItem.image = UIImage(named: "Pause-50")!
            player.pause()
        case UIEventSubtype.RemoteControlPlay:
            self.tabBarItem.selectedImage = UIImage(named: "Play Filled-50")
            self.tabBarItem.image = UIImage(named: "Play-50")
            player.play()
        case UIEventSubtype.RemoteControlNextTrack:
            currently_playing = false
            updateTables()
        case UIEventSubtype.RemoteControlStop:
            currently_playing = false
            updateTables()
        default:
            print("error")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queued_songs?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Queue") as! QueueMusicTableViewCell
        cell.artist.text = queued_songs![indexPath.row].artist
        cell.song_title.text = queued_songs![indexPath.row].title!
        if indexPath.row > 0 {
            cell.number.text = "\(indexPath.row)"
        } else {
            cell.number.text = "Next"
        }
        let image = queued_songs![indexPath.row].artwork
        cell.artwork.image = UIImage(data: image!)
        return cell
    }

}
