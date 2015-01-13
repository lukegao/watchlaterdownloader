//
//  ViewController.swift
//  MacApp
//
//  Created by Luke Gao on 11/13/14.
//  Copyright (c) 2014 Luke Gao. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

let CLIENT_ID = "365805353701-rq0srr6lhrs65seots6oqf4grl61bi2i.apps.googleusercontent.com"
let CLIENT_SECRET = "XWKZEDuuC-b52B9p7AOYYiFO"
let YOUTUBE_SCOPE = "https://www.googleapis.com/auth/youtube"

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var userInfoButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    var channelId: String = ""
    var playlistId: String = ""
    var wlList = [GTLYouTubePlaylistItem]()
    
    var service: GTLServiceYouTube? {
        didSet {
            service?.authorizer = self.auth
            self.fetchChannelLists()
        }
    }
    
    var auth: GTMOAuth2Authentication? {
        didSet {
            if let mail = auth?.userEmail {
                self.userInfoButton.title = mail
                self.userInfoButton.transparent = false
                self.service = GTLServiceYouTube()
            } else {
                self.userInfoButton.title = ""
                self.userInfoButton.transparent = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userInfoButton.transparent = true
        self.auth = GTMOAuth2WindowController.authForGoogleFromKeychainForName("WatchLaterDownloader", clientID: CLIENT_ID, clientSecret: CLIENT_SECRET)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func showUserInfo(sender: NSButton) {
    }
    
    @IBAction func oauthGTM(sender: NSButton) {
        var gtmvc = GTMOAuth2WindowController(scope: YOUTUBE_SCOPE, clientID: CLIENT_ID, clientSecret: CLIENT_SECRET, keychainItemName: "WatchLaterDownloader", resourceBundle: nil)
        
        gtmvc.signInSheetModalForWindow(self.view.window, completionHandler: {
            (auth: GTMOAuth2Authentication!, error: NSError!) in
            if error != nil {
                println(error)
            }
            self.auth = auth
        })
    }
    
    @IBAction func signOut(sender: NSButton) {
        GTMOAuth2WindowController.removeAuthFromKeychainForName("WatchLaterDownloader")
        GTMOAuth2WindowController.revokeTokenForGoogleAuthentication(self.auth)
        self.auth = nil
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.wlList.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        return nil
    }
    
    private func fetchVideo(id: String) {
        var query = GTLQueryYouTube.queryForVideosListWithPart("snippet") as GTLQueryYouTube
        query.identifier = id
        
        var ticket = self.service!.executeQuery(query, completionHandler: {
            (ticket: GTLServiceTicket!, data: AnyObject!, error: NSError!) in
            if error != nil {
                println(error)
            } else {
                var response = data as GTLYouTubeVideoListResponse
                if response.items().count > 0 {
                    var video = response.items()[0] as GTLYouTubeVideo
                    println(video.snippet.title)
                }
            }
        })
    }

    private func fetchListItem() {
        var query = GTLQueryYouTube.queryForPlaylistItemsListWithPart("contentDetails") as GTLQueryYouTube
        // set playlistid property
        query.playlistId = self.playlistId
        query.maxResults = 50
        
        var ticket = self.service!.executeQuery(query, completionHandler: {
            (ticket: GTLServiceTicket!, data: AnyObject!, error: NSError!) in
            if error != nil {
                println(error)
            }
            else {
                var response = data as GTLYouTubePlaylistItemListResponse
                println("item count: ", response.items().count)
                self.wlList.removeAll(keepCapacity: false)
                for var index = 0; index < response.items().count; index++ {
                    var videoItem = response.items()[index] as GTLYouTubePlaylistItem
                    self.wlList.append(videoItem)
                    self.fetchVideo(videoItem.contentDetails.videoId)
                }
            }
        })
    }
    
    private func fetchListContents() {
        var query: GTLQueryYouTube = GTLQueryYouTube.queryForPlaylistsListWithPart("id") as GTLQueryYouTube
        query.identifier = self.channelId
        
        var ticket = self.service!.executeQuery(query, completionHandler: {
            (ticket: GTLServiceTicket!, data: AnyObject!, error: NSError!) in
            if error != nil {
                println(error)
            } else {
                var response: GTLYouTubePlaylistListResponse = data as GTLYouTubePlaylistListResponse
                print("Play list items:")
                for var index = 0; index < response.items().count; index++ {
                    var playList: GTLYouTubePlaylist = response.items()[index] as GTLYouTubePlaylist
                    println(playList.identifier)
                    self.playlistId = playList.identifier
                    self.fetchListItem()
                }
            }
        })
    }
    
    private func fetchChannelLists() {
        var query: GTLQueryYouTube = GTLQueryYouTube.queryForChannelsListWithPart("contentDetails") as GTLQueryYouTube
        query.mine = true
        
        var ticket = self.service!.executeQuery(query, completionHandler: {
            (ticket :GTLServiceTicket!, data: AnyObject!, error: NSError!) in
            if error != nil {
                println(error)
            } else {
                var response: GTLYouTubeChannelListResponse = data as GTLYouTubeChannelListResponse
                if response.items().count > 0 {
                    var channel: GTLYouTubeChannel = response.items()[0] as GTLYouTubeChannel
                    self.channelId = channel.contentDetails.relatedPlaylists.watchLater
                    println("Playlist id: " + self.channelId)
                }
                
                if !self.channelId.isEmpty {
                    self.fetchListContents()
                }
            }
        })
    }
}
