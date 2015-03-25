//
//  AVPlayerView.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 18/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView : UIView {
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var videoPlayer: AVPlayer? {
        set {
            let layer: AVPlayerLayer = self.layer as AVPlayerLayer
            layer.player = newValue
            layer.videoGravity = AVLayerVideoGravityResizeAspect
        }
        get {
            let layer: AVPlayerLayer = self.layer as AVPlayerLayer
            return layer.player
        }
    }
    private var videoPlayerItem: AVPlayerItem?
    
    func loadVideo(sourceURL: String)
    {
        let url = NSURL(string: sourceURL)
        videoPlayerItem = AVPlayerItem(URL: url)
        if let playerItem = videoPlayerItem {
            videoPlayer = AVPlayer(playerItem: playerItem)
            if let player = videoPlayer {
                player.actionAtItemEnd = .None
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideo:", name: AVPlayerItemDidPlayToEndTimeNotification, object: videoPlayer?.currentItem)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideo:", name: UIApplicationDidBecomeActiveNotification, object: .None)
                player.play()
            }
        }
    }
    
    func reloadVideo(notification: NSNotification)
    {
        if let player = videoPlayer {
            player.seekToTime(CMTimeMake(0, 1))
            player.play()
        }
    }
}
