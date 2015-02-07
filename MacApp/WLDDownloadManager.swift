//
//  WLDDownloadManager.swift
//  MacApp
//
//  Created by Luke Gao on 1/28/15.
//  Copyright (c) 2015 Luke Gao. All rights reserved.
//

import Foundation

let DownloadDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DownloadsDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: nil)

class WLDVideoInstance: NSObject, NSURLDownloadDelegate {
    let title: String
    var localUrl: String!
    let originUrl: NSURL!
    let video: XCDYouTubeVideo
    
    init(video :XCDYouTubeVideo!) {
        self.video = video
        title = video.title

        super.init()
        originUrl = extractUrl()
    }
    
    private func extractUrl() -> NSURL! {
        var sd = video.streamURLs[18] as NSURL?
        var hd = video.streamURLs[22] as NSURL?
        
        if hd != nil {
            return hd
        } else {
            return sd
        }
    }
}
