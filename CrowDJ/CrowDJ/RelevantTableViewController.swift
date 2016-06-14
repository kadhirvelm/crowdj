//
//  RelevantTableViewController.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class RelevantTableViewController: UITableViewController {

    let coreData = crowdjCoreData()
    var next_song: Music_queue?
    var curr_song: [String: AnyObject?]?
    var curr_sesh_id = 0
    var refreshControl1 = UIRefreshControl()
    
    var current_data = ["hot":0,"cold":0]
    var all_music_items: [MPMediaItem]?
    var all_music_sorted: [String: [MPMediaItem]]?
    var recommend_item: MPMediaItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        all_music_items = MPMediaQuery.songsQuery().items!
        sort_into_genres(all_music_items)
        self.refreshControl1.addTarget(self, action: #selector(RelevantTableViewController.updateTable), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl1.tintColor = UIColor.whiteColor()
    }
    
    func sort_into_genres(all_music_items: [MPMediaItem]?) {
        all_music_sorted = ["None": []]
        if all_music_items?.count > 0 {
            for song in all_music_items! {
                if song.genre != nil {
                    if (all_music_sorted![song.genre!] != nil) {
                        all_music_sorted![song.genre!]!.append(song)
                    } else {
                        all_music_sorted![song.genre!] = [song]
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateTable()
        post_get_data()
        self.tableView.addSubview(self.refreshControl1)
    }
    
    func post_start_request(sesh_number: Int) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://djcrow.herokuapp.com/start_poll/\(sesh_number)/")!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
            }
        }
        task.resume()
    }
    
    func post_stop_all_sessions(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://djcrow.herokuapp.com/stop_poll/")!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
            }
        }
        task.resume()
    }
    
    func post_get_data() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://djcrow.herokuapp.com/get_results/")!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            do {
                let json =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                self.current_data["hot"] = (json["hot"] as? Int)!
                self.current_data["cold"] = (json["cold"] as? Int)!
                dispatch_async(dispatch_get_main_queue(), {
                    self.checkForRecommendation()
                    self.tableView.reloadData()
                    self.refreshControl1.endRefreshing()
                })
            } catch {
                print("Errors: \(error)")
            }
        }
        task.resume()
    }
    
    func updateTable() {
        let all_songs = (coreData.retrieveData("Music_queue") as? [Music_queue])!
        if all_songs.count > 0 {
            next_song = all_songs[0]
        }
        curr_song = MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo
        if curr_song != nil {
            post_get_data()
            curr_sesh_id = (curr_song![MPMediaItemPropertyTitle] as! String).hashValue
        } else {
            self.tableView.reloadData()
            refreshControl1.endRefreshing()
        }
    }
    
    func checkForRecommendation() {
        let positive = current_data["hot"]
        let negative = current_data["cold"]
        if (positive! + negative!) >= 7 {
            if positive > negative {
                recommend_same_genre()
            } else {
                recommend_different_genre()
            }
        }
    }
    
    func recommend_same_genre() {
        if curr_song != nil {
            if let curr_genre = curr_song![MPMediaItemPropertyGenre] {
                for (key, value) in all_music_sorted! {
                    if key == (curr_genre as? String) {
                        let generator = Int(arc4random_uniform(UInt32(value.count)))
                        recommend_item = value[generator]
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func recommend_different_genre() {
        if curr_song != nil {
            if let curr_genre = curr_song![MPMediaItemPropertyGenre] {
                for (key, value) in all_music_sorted! {
                    if key != (curr_genre as? String) {
                        let generator = Int(arc4random_uniform(UInt32(value.count)))
                        recommend_item = value[generator]
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Relevant", forIndexPath: indexPath) as! RelevantTableViewCell
        
        switch (indexPath.row) {
        case 0:
            cell = set_current_song(cell)
        case 1:
            cell = set_next_song(cell)
        case 2:
            cell = set_recommendation(cell)
        default:
            return cell
        }
        return cell
    }
    
    func set_current_song(cell: RelevantTableViewCell) -> RelevantTableViewCell {
        cell.add_to_queue.enabled = false
        cell.add_to_queue.hidden = true
        cell.top_right_label.text = "Currently Playing"
        if curr_song != nil {
            let artwork = curr_song![MPMediaItemPropertyArtwork] as? MPMediaItemArtwork
            cell.song_image.image = artwork?.imageWithSize(cell.song_image.frame.size)
            cell.artist.text = (curr_song![MPMediaItemPropertyArtist]! as? String)!
            cell.title.text = (curr_song![MPMediaItemPropertyTitle]! as? String)!
            cell.thumbs_up.image = UIImage(named: "Green Up-1")
            cell.thumbs_down.image = UIImage(named: "Red Down-1")
            cell.num_up.text = "\(current_data["hot"] ?? 0)"
            cell.num_down.text = "\(current_data["cold"] ?? 0)"
        } else {
            cell.artist.text = ""
            cell.title.text = "No songs playing"
        }
        return cell
    }
    
    func set_next_song(cell: RelevantTableViewCell) -> RelevantTableViewCell {
        cell.add_to_queue.enabled = false
        cell.add_to_queue.hidden = true
        cell.top_right_label.text = "Next Up"
        if next_song != nil {
            cell.title.text = next_song?.title
            cell.artist.text = next_song?.artist
            cell.song_image.image = UIImage(data: (next_song?.artwork)!)
        } else {
            cell.artist.text = ""
            cell.title.text = "No songs queued"
        }
        return cell
    }
    
    func set_recommendation(cell: RelevantTableViewCell) -> RelevantTableViewCell {
        cell.top_right_label.text = "Recommendation"
        if recommend_item == nil {
            cell.title.text = "Not enough votes"
            cell.artist.text = "Need at least 7 votes"
        } else {
            cell.title.text = recommend_item?.title
            cell.artist.text = recommend_item?.artist
            cell.song_image.image = recommend_item?.artwork?.imageWithSize(cell.song_image.frame.size)
        }
        return cell
    }

}
