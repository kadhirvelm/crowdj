//
//  LibraryViewController.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var all_music_items: [MPMediaItem]?
    var player: AVAudioPlayer?
    
    @IBOutlet weak var musicTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        all_music_items = MPMediaQuery.songsQuery().items!
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all_music_items?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCellWithIdentifier("Music") as? MusicTableViewCell
        cell?.music_artist.text = all_music_items![indexPath.row].artist
        cell?.music_title.text = all_music_items![indexPath.row].title
        let image = all_music_items![indexPath.row].artwork
        let size = cell?.frame.size
        cell?.music_image.image = image?.imageWithSize(size!)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let coreData = crowdjCoreData()
        let song_selected = all_music_items![indexPath.row]
        let imageData = song_selected.artwork
        let size = tableView.frame.size
        let image = imageData?.imageWithSize(size)
        let data = UIImagePNGRepresentation(image!)
        let url = indexPath.row
        let title = song_selected.title
        let artist = song_selected.artist
        let playback = String(song_selected.playbackDuration)
        let genre = song_selected.genre
        coreData.createNewMusic(url, title: title!, artist: artist!, artwork: data!, playback: playback, genre: genre!)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
