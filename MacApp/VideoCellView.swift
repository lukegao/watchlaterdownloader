//
//  VideoCellView.swift
//  MacApp
//
//  Created by Luke Gao on 1/14/15.
//  Copyright (c) 2015 Luke Gao. All rights reserved.
//

import Cocoa

class VideoCellView: NSTableCellView {
    var video: XCDYouTubeVideo!
    var contentLength: Int64 = 0
    var currentLength: Int64 = 0
    
    var download: NSURLDownload!
    var isDownloading: Bool = false
    var localUrl: NSURL!
    
    @IBOutlet weak var thumnailView: NSImageView!
    @IBOutlet weak var titleView: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var downloadButton: NSButton!
    
    @IBAction func playVideo(sender: NSButton) {
        if isDownloading {
            println("trying to cancel current downloading...")
            download.cancel()
            isDownloading = false
            return
        }
        
        if let video = self.video {
            var sdVideo = video.streamURLs[18] as NSURL?
            var hdVideo = video.streamURLs[22] as NSURL?
            
            if hdVideo != nil {
                startDownload(hdVideo)
            } else if sdVideo != nil {
                startDownload(sdVideo)
            } else {
                println("no mp4 video")
            }
        }
        else {
            println("no video available")
        }
    }
    
    private func startAFDownload(url: NSURL!) {
        var req = NSURLRequest(URL: url)
        var manager = AFHTTPSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var task = manager.downloadTaskWithRequest(req, progress: nil, destination: {
            (url: NSURL!, response: NSURLResponse!) in
            var targetUrl = url.URLByAppendingPathComponent(response.suggestedFilename!)
            return targetUrl
            }, completionHandler: {
                (response: NSURLResponse!, url: NSURL!, error: NSError!) in
                if error != nil {
                    println(error.description)
                }
        })
        task.resume()
    }
    
    private func startDownload(url: NSURL!) {
        let req = NSURLRequest(URL: url)
        download = NSURLDownload(request: req, delegate: self)
        progressBar.doubleValue = 0.0
    }
}

extension VideoCellView: NSURLDownloadDelegate {

    func downloadDidBegin(download: NSURLDownload) {
        isDownloading = true
    }
    
    func download(download: NSURLDownload, didFailWithError error: NSError) {
        isDownloading = false
        println("download failed with error code \(error.code)")
    }
    
    func download(download: NSURLDownload, didReceiveResponse response: NSURLResponse) {
        contentLength = response.expectedContentLength
        if let url = DownloadDirectory {
            localUrl = url.URLByAppendingPathComponent(video.title + ".mp4")
            download.setDestination(localUrl.path!, allowOverwrite: false)
        }
        println("expected content length: \(response.expectedContentLength)")
    }
    
    func download(download: NSURLDownload, didReceiveDataOfLength length: Int) {
        currentLength += length
        progressBar.doubleValue = (Double(currentLength) / Double(contentLength)) * 100.0
    }
    
    func downloadDidFinish(download: NSURLDownload) {
        if let video = self.video {
            println("finished downloading video " + video.title)
        }
    }
}
