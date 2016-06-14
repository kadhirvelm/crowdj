//
//  RelevantTableViewCell.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import UIKit

class RelevantTableViewCell: UITableViewCell {

    @IBOutlet weak var song_image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var top_right_label: UILabel!
    @IBOutlet weak var add_to_queue: UIButton!
    
    @IBOutlet weak var thumbs_up: UIImageView!
    @IBOutlet weak var thumbs_down: UIImageView!
    @IBOutlet weak var num_down: UILabel!
    @IBOutlet weak var num_up: UILabel!
    
    @IBAction func AddToQueue(sender: UIButton) {
//        let coreData = crowdjCoreData()
//        let data = UIImagePNGRepresentation(song_image.image)
//        let url = indexPath.row
//        let title = song_selected.title
//        let artist = song_selected.artist
//        let playback = String(song_selected.playbackDuration)
//        coreData.createNewMusic(url, title: title!, artist: artist!, artwork: data!, playback: playback)
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
