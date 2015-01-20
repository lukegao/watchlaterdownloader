//
//  VideoCellView.swift
//  MacApp
//
//  Created by Luke Gao on 1/14/15.
//  Copyright (c) 2015 Luke Gao. All rights reserved.
//

import Cocoa

class VideoCellView: NSTableCellView, NSURLDownloadDelegate {
    var video: XCDYouTubeVideo?
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var labelView: NSTextField!
    
    @IBAction func playVideo(sender: NSButton) {
        if let video = self.video {
            var sdVideo = video.streamURLs[18] as NSURL?
            var hdVideo = video.streamURLs[22] as NSURL?
            
            if hdVideo != nil {
                var req = NSURLRequest(URL: hdVideo!)
                var task = NSURLDownload(request: req, delegate: self)
                //task.setDestination(NSHomeDirectory(), allowOverwrite: true)
            } else if sdVideo != nil {
                var req = NSURLRequest(URL: sdVideo!)
                var task = NSURLDownload(request: req, delegate: self)
                //task.setDestination(NSHomeDirectory(), allowOverwrite: true)
            } else {
                println("no mp4 video")
            }
        }
        else {
            println("no video available")
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    func downloadDidBegin(download: NSURLDownload) {
        if let video = self.video {
            println(video.title + " begin downloading.")
        }
    }
    
    func download(download: NSURLDownload, didFailWithError error: NSError) {
        println("download failed with error code " + error.code)
    }
    
    func downloadDidFinish(download: NSURLDownload) {
        if let video = self.video {
            println("finished downloading video " + video.title)
        }
    }
}
