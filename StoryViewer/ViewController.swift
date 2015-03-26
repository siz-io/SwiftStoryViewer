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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let storyViewController = segue.destinationViewController as? StoryViewController {
            self.storyViewController = storyViewController
        }
    }
    
}


