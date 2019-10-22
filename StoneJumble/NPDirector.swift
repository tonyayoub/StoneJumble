//
//  NPDirector.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/7/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit
import GoogleMobileAds


class NPDirector: NSObject
{    
    static let shared: NPDirector = {
        let instance = NPDirector()
        // setup code
        return instance
    }()
    
    
    let burgerTextures = TextureManager()
    
    var currentEpisodeID:Int = GameData.shared.maxProgress.episode
    var currentLevelID:Int = 1
    var gamePaused = false
    var hasGoldToAdd = false
    var onAdDismissed:(() -> Void)?
    private var banner: GADBannerView?

    var bannerView:GADBannerView?
    {
        get
        {
            return banner
        }
        set(newValue)
        {
            banner = newValue
        }
    }
    func hideBanner()
    {
        banner?.isHidden = true
    }
    func showBanner()
    {
        banner?.isHidden = true
    }

    
    //scenes and views
    
    var skView:SKView?
    
    var mainMenuScene:MainMenu?

    //show ads or not
    var showAds:Bool
    {
        get
        {
            return (NPDirector.shared.currentEpisodeID > 1)
                || (NPDirector.shared.currentLevelID > 4)
        }
    }

    //sizes
    var viewSize:CGSize = CGSize(width: 0.0, height: 0.0)
    var episodeTitleSize:CGFloat
    {
        get
        {
            return viewSize.width / 15
        }
    }
    var levelLabeleSize:CGFloat
    {
        get
        {
            return viewSize.width / 20
        }
    }
    var hitsLabelSize:CGFloat
    {
        get
        {
            return viewSize.width / 16
        }
    }
    var levelImageSize:CGSize
    {
        get
        {
            return CGSize(width: viewSize.width/10, height: viewSize.width/10)
        }
    }
    

    var soundEnabled:Bool
    {
        get
        {
            if let currentValue =  PlistManager.sharedInstance.getValueForKey(key: "sound") as? Bool
            {
                return currentValue
            }
            else
            {
                return true
            }
        }
        set(newValue)
        {
            PlistManager.sharedInstance.saveBoolValue(value: newValue, forKey: "sound")
            if let currentScene = SJLevelScene.currentLevelScene
            {
                if newValue
                {
                    if SJDirector.shared.isTimeLevel
                    {
                        currentScene.playTickSound()
                    }
                }
                else
                {
                    currentScene.removeAction(forKey: "tick")
                }

            }

        }
    }

    var musicEnabled:Bool
    {
        get
        {
            if let currentValue =  PlistManager.sharedInstance.getValueForKey(key: "music") as? Bool
            {
                return currentValue
            }
            else
            {
                return true
            }
        }
        set(newValue)
        {
            PlistManager.sharedInstance.saveBoolValue(value: newValue, forKey: "music")
        }
    }


    class func changeSoundEnabled()
    {
        NPDirector.shared.soundEnabled = !NPDirector.shared.soundEnabled
    }

    class func changeMusicEnabled()
    {
        NPDirector.shared.musicEnabled = !NPDirector.shared.musicEnabled
        if NPDirector.shared.musicEnabled
        {
            SJDirector.shared.playBGMusic()
        }
        else
        {
            SJDirector.shared.stopBGMusic()
        }
    }
    
    class func displayMainMenu()
    {
        let scene = MainMenu(size: (NPDirector.shared.skView!.bounds.size))
        scene.scaleMode = .aspectFill
        shared.skView?.presentScene(scene)
        scene.createMainMenuLables()
        MainMenu.menuStatus = .StartingMenu
    }
    
    class func displayCurrentEpisodeMenu()
    {
        let scene = MainMenu(size: (NPDirector.shared.skView!.bounds.size))
        scene.scaleMode = .aspectFill
        shared.skView?.presentScene(scene)
        scene.createEpisodeMenu()
        MainMenu.menuStatus = .EpisodeMenu
    }

    static func loadAdMobVideo()
    {
        
    }
    static func showAdMobVideo()
    {

    }
    static func showAdBeforeLevelRepeat()
    {
        let showBeforeRepeat = false
        if(showBeforeRepeat && NPDirector.shared.showAds && Chartboost.hasInterstitial(CBLocationLevelComplete))
        {
            // print("will show ad before repeating level...")
            SJDirector.shared.stopBGMusic()
            Chartboost.showInterstitial(CBLocationLevelComplete)
            SJLevelScene.status = .showingAdAtRepeat
            NPDirector.shared.onAdDismissed = repeatLevel
            
        }
        else
        {
            // print("no ad cached, will repeat without ads >>>>>>>")
            SJLevelScene.status = .start

            repeatLevel()
        }
    }
    
    static func showAdBeforeLevelStart()
    {
        let showAdsBetweenLevels = false;
        if(showAdsBetweenLevels &&
            NPDirector.shared.showAds &&
            Chartboost.hasInterstitial(CBLocationLevelComplete))
        {
            SJDirector.shared.stopBGMusic()
            // print("will show ad before next level...")
            Chartboost.showInterstitial(CBLocationLevelComplete)
            SJLevelScene.status = .showingAdAtStart
            NPDirector.shared.onAdDismissed = proceed
            
        }
        else
        {
            // print("no ad cached, will proceed without ads >>>>>>>")
            SJLevelScene.status = .start
            proceed()
        }
    }

    
    static func proceed()
    {
        let newProgress = GameData.calculateNextProgress(episode: NPDirector.shared.currentEpisodeID, level: NPDirector.shared.currentLevelID)
        NPDirector.startBoardLevel(episodeID: newProgress.newEpisode, levelID: newProgress.newLevel)
    }
    static func repeatLevel()
    {
        startBoardLevel(episodeID: NPDirector.shared.currentEpisodeID, levelID: NPDirector.shared.currentLevelID)// same level again
    }
    
  
    static func runActionAfterAdDismissed()
    {
        print("Ad dismissed...")
        if let functionAfterAd = NPDirector.shared.onAdDismissed
        {
            functionAfterAd()
            NPDirector.shared.gamePaused = false
        }
    }
    
    
    
    class func showEmitter(_ emitterFile: String, position: CGPoint, parentNode: SKNode, lifetime: Double)
    {
        if let emitter = SKEmitterNode(fileNamed: emitterFile)
        {
            emitter.position = position
            emitter.name = "sparkEmmitter"
            emitter.zPosition = 199
            emitter.targetNode = parentNode
     
            
            parentNode.addChild(emitter)
            if lifetime != 0 //0 means infinity
            {
                let waitAction = SKAction.wait(forDuration: lifetime)
                let removeAction = SKAction.removeFromParent()
                emitter.run(SKAction.sequence([waitAction, removeAction]))
            }
        }
    }
    
    
    
    

    
    
    

    
    class func startBoardLevel(episodeID: Int, levelID: Int)
    {
        
        NPDirector.shared.gamePaused = true
        shared.currentEpisodeID = episodeID
        shared.currentLevelID = levelID

        
        
   
        let levelScene = SJLevelScene(size: shared.viewSize)
        if !SJLevelCreator.createObjects()
        {
            NPDirector.terminateMessage()
            return
        }
        
        let trans1 = SKTransition.fade(with: SKColor.darkGray, duration: 0.5)
        shared.skView?.presentScene(levelScene, transition: trans1)
    }
    
    class func showStartMessage(episodeID: Int, levelID: Int, parentScene: SKNode)
    {
        Boxes.showStartMessage(episdoeID: episodeID, levelID: levelID, parentScene: parentScene)
    }
    

    
    class func terminateMessage()
    {
        let alert = UIAlertController(title: "Error", message: "Cannot parse data for this level", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        if let viewController = shared.skView?.window?.rootViewController
        {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
