//
//  VideoViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 01/04/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playerView: AVPlayerView!

    private var videoPlayer: AVPlayer?
    private var videoPlayerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func loadVideo(sourceURL: String)
    {
        spinner.startAnimating()
        let url = NSURL(string: sourceURL)
        videoPlayerItem = AVPlayerItem(URL: url)
        if let playerItem = videoPlayerItem {
            videoPlayer = AVPlayer(playerItem: playerItem)
            if let player = videoPlayer {
                player.actionAtItemEnd = .None
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "play", name: AVPlayerItemDidPlayToEndTimeNotification, object: videoPlayer?.currentItem)
                playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
                playerView.videoPlayer = player
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if videoPlayerItem?.status == AVPlayerItemStatus.ReadyToPlay {
            videoLoaded()
        }
    }
    
    func videoLoaded()
    {
        spinner.stopAnimating()
        play()
    }

    func play()
    {
        if let player = videoPlayer {
            player.seekToTime(CMTimeMake(0, 1))
            player.play()
        }
    }
}
