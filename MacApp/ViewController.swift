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

class ViewController: NSViewController {
    @IBOutlet weak var userInfoButton: NSButton!
    
    var auth: GTMOAuth2Authentication! {
        didSet {
            if let mail = auth.userEmail {
                self.userInfoButton.title = mail
                self.userInfoButton.transparent = false
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
        self.userInfoButton.title = ""
        self.userInfoButton.transparent = true
    }
    
}
