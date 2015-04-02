//
//  ViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 17/03/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var storyViewContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var storyViewController: StoryViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewStory()
        NSNotificationCenter.defaultCenter().addObserver(storyViewController, selector: "play", name: UIApplicationDidBecomeActiveNotification, object: .None)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        storyViewController.play()
    }
    
    
    func loadNewStory() {
        Story.getNextStory() {
            self.storyViewController.story = $0
        }
    }
    
    private struct Constants {
        static let translationScale: CGFloat = 1.5
        static let timeToReturnToIdentity = 0.3
        static let timeToExitStory = 0.25
        static let minPercentOfPan: Float = 0.30
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let storyViewController = segue.destinationViewController as? StoryViewController {
            self.storyViewController = storyViewController
        }
    }
    
    @IBAction func dragStory(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            let screenWidth = self.view.bounds.width
            let minTranslationX = Float(screenWidth)*Constants.minPercentOfPan
            let translationX = Float(gesture.translationInView(storyViewContainer).x*Constants.translationScale)
            let rightTranslation = translationX > 0
            if(abs(translationX) > minTranslationX)
            {
                UIView.animateWithDuration(
                    Constants.timeToExitStory,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseOut,
                    animations: {
                        self.storyViewContainer.transform = CGAffineTransformMakeTranslation(rightTranslation ? screenWidth : -screenWidth, 0)
                    },
                    completion: { (result:Bool) in
                        self.loadNewStory()
                        self.storyViewController.play()
                        self.returnToIdentity(0)
                    }
                )
                
            } else {
                returnToIdentity(Constants.timeToReturnToIdentity)
            }
            
            println("TranslationX=\(translationX) MinTranslationX=\(minTranslationX)")
        case .Changed:
            let translation = gesture.translationInView(storyViewContainer)
            let xOffset = translation.x * Constants.translationScale
            if xOffset != 0 {
                self.storyViewContainer.transform = CGAffineTransformMakeTranslation(xOffset,0)
            }
        default: break
        }
    }
    
    func returnToIdentity(time: Double){
        UIView.animateWithDuration(
            time,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.storyViewContainer.transform = CGAffineTransformIdentity
            },
            completion: .None
        )
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


