//
//  VideoCellView.swift
//  MacApp
//
//  Created by Luke Gao on 1/14/15.
//  Copyright (c) 2015 Luke Gao. All rights reserved.
//

import Cocoa

class VideoCellView: NSTableCellView {
    var html: String = "Undefined embedhtml"
    var video: XCDYouTubeVideo?
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var labelView: NSTextField!
    
    @IBAction func playVideo(sender: NSButton) {
//        if self.video != nil {
//            var url = self.video?.streamURLs["22"] as NSURL
//            println("video url" + url.description)
//        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
