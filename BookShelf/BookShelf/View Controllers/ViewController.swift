//
//  ViewController.swift
//  BookShelf
//
//  Created by ChelseaAnne Castelli on 3/18/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up background video
//        setUpVideo()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

    func setUpVideo() {
        
        //Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "vid_2", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        //Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        //Create video player item
        let item = AVPlayerItem(url: url)
        
        //Create player
        videoPlayer = AVPlayer(playerItem: item)
        
        //Create layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //Adjust size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*2, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //Add it to view & play
        videoPlayer?.playImmediately(atRate: 0.1)
        
        
    }

}

