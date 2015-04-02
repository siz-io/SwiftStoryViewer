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
    private var videoPlayerItem: AVPlayerItem? {
        willSet {
            if let playerItem = videoPlayerItem {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
                playerItem.removeObserver(self, forKeyPath: "status")
            }
        }
    }
    
    var sourceURL: String? {
        didSet {
            loadVideo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func loadVideo()
    {
        if let stringURL = sourceURL {
            spinner.startAnimating()
            let url = NSURL(string: stringURL)
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
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let playerItem = videoPlayerItem {
            switch playerItem.status {
            case AVPlayerItemStatus.ReadyToPlay:
                spinner.stopAnimating()
                play()
            case AVPlayerItemStatus.Failed:
                spinner.stopAnimating()
                println("Failed to load video \(sourceURL)")
            default: break
            }
        }
    }


    func play()
    {
        if let player = videoPlayer {
            player.seekToTime(CMTimeMake(0, 1))
            player.play()
        }
    }
}
