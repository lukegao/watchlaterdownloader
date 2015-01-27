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
    var contentLength: Int64 = 0
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var labelView: NSTextField!
    
    @IBAction func playVideo(sender: NSButton) {
        if let video = self.video {
            var sdVideo = video.streamURLs[18] as NSURL?
            var hdVideo = video.streamURLs[22] as NSURL?
            
            if hdVideo != nil {
                var req = NSURLRequest(URL: hdVideo!)
                var download = NSURLDownload(request: req, delegate: self)
            } else if sdVideo != nil {
                var req = NSURLRequest(URL: sdVideo!)
                var download = NSURLDownload(request: req, delegate: self)
            } else {
                println("no mp4 video")
            }
        }
        else {
            println("no video available")
        }
    }
    
    func downloadDidBegin(download: NSURLDownload) {
        if let video = self.video {
            println(video.title + " begin downloading.")
        }
    }
    
    func download(download: NSURLDownload, didFailWithError error: NSError) {
        println("download failed with error code \(error.code)")
    }
    
    func download(download: NSURLDownload, didReceiveResponse response: NSURLResponse) {
        self.contentLength = response.expectedContentLength
        println("expected content length: \(response.expectedContentLength)")
    }
    
    func download(download: NSURLDownload, didReceiveDataOfLength length: Int) {
        println("downloaded size: \(length) of \(self.contentLength)...")
    }
    
    func download(download: NSURLDownload, decideDestinationWithSuggestedFilename filename: String) {
        if var downloadURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DownloadsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil) as NSURL? {
            downloadURL.URLByAppendingPathComponent(filename)
            if (downloadURL.path != nil) {
                download.setDestination(downloadURL.path!, allowOverwrite: false)
                println("Download location set to \(downloadURL.path!)")
            }
        }
    }
    
    func downloadDidFinish(download: NSURLDownload) {
        if let video = self.video {
            println("finished downloading video " + video.title)
        }
    }
}
