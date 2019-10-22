//
//  GameViewController.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/4/15.
//  Copyright (c) 2015 amahy. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController
{

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        if(NPDirector.shared.musicEnabled)
        {
            SJDirector.shared.playBGMusic()
        }

        if let currentSKView = self.view as! SKView?
        {
            //self.view is set to be of type SKView inside Main.storyboard
            
      //      currentSKView.showsFPS = true
     //       currentSKView.showsNodeCount = true
            currentSKView.ignoresSiblingOrder = true
            NPDirector.shared.skView = currentSKView
            NPDirector.shared.viewSize = self.view.bounds.size

        }
        NPDirector.displayMainMenu()
        createAdMobBanner()
        
    }

    func createAdMobBanner()
    {
        NPDirector.shared.bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        guard let banner = NPDirector.shared.bannerView else
        {
            return;
        }

        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        view.addConstraints(
            [NSLayoutConstraint(item: banner,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: topLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: banner,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])


        //test ad unit id:
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"

        //my actual ad unit id (banner):
      //  banner.adUnitID = "ca-app-pub-6439333454694134/7386742763"

        //rewarded video ad unit id
        //ca-app-pub-6439333454694134/8090744252

        
        banner.rootViewController = self
        banner.isHidden = true
        banner.load(GADRequest())

    }
    override var shouldAutorotate : Bool
    {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
