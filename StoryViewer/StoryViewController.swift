//
//  StoryViewController.swift
//  StoryViewer
//
//  Created by Julien DAUPHANT on 09/04/15.
//  Copyright (c) 2015 Siz. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    weak var gridViewController: StoryGridViewController!

    var story: Story? {
        didSet {
            if let model = story {
                titleLabel.text = model.title
                gridViewController.story = model
            } else {
                titleLabel.text = .None
            }
        }
    }
    
    func play()
    {
        gridViewController.play()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let gridViewController = segue.destinationViewController as? StoryGridViewController {
            self.gridViewController = gridViewController
        }
    }
}
