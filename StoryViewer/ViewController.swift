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
    
    var storyViewController: StoryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyViewController.loadStory("1426589791593b2493fba815")
    }
    
    private struct Constants {
        static let translationScale: CGFloat = 2
        static let timeToReturnToIdentity = 0.5
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let storyViewController = segue.destinationViewController as? StoryViewController {
            self.storyViewController = storyViewController
        }
    }
    @IBAction func dragStory(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            UIView.animateWithDuration(
                Constants.timeToReturnToIdentity,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    self.storyViewContainer.transform = CGAffineTransformIdentity
                },
                completion: .None
            )
            
        case .Changed:
            let translation = gesture.translationInView(storyViewContainer)
            let xOffset = translation.x * Constants.translationScale
            if xOffset != 0 {
                self.storyViewContainer.transform = CGAffineTransformMakeTranslation(xOffset,0)
            }
        default: break
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


