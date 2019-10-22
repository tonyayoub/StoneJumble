//
//  SJDirector.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/7/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit
import AVFoundation


class SJDirector: NSObject
{
    private static let _sharedDirector = SJDirector()

    class var shared: SJDirector
    {
        return _sharedDirector
    }

    var goldCredit:Int
    {
        get
        {
            return ProgressManager.getCredit()
        }
        set(newCredit)
        {
            SJLevelScene.currentLevelScene?.goldLabel.text = "\(newCredit)"
            ProgressManager.saveCredit(value: newCredit)
        }
    }


    class func anyObjectIsMovingFromCollection(_ objects: [SKNode])->Bool
    {
        return true
    }
    
    class func friesEnd()
    {
        // print("fries ended")
    }
    
    class func sodaEnd()
    {
        // print("soda ended")
    }
//    let colorNames = ["red", "green", "blue", "orange", "violet", "donutA"]

    static let maxStrength = 9
    var _hitsRemaining = 0
    var _timeRemaining = 0
    var originalNumberOfHits = 0
    var isTimeLevel = false
    var bgMusic: AVAudioPlayer?

    func playBGMusic()
    {
        let path = Bundle.main.path(forResource: "spoons.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do
        {
            bgMusic = try AVAudioPlayer(contentsOf: url)
            bgMusic?.numberOfLoops = -1
            bgMusic?.play()
        }
        catch
        {
            // couldn't load file :(
        }
    }

    func stopBGMusic()
    {
        let path = Bundle.main.path(forResource: "spoons.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do
        {
            bgMusic = try AVAudioPlayer(contentsOf: url)
            bgMusic?.stop()
        }
        catch
        {
            // couldn't load file :(
        }
    }


    //Level parser and models
    
    
    
    var currentLevelScene:SJLevelScene? = nil
    var reactions:ObjectsReactions = ObjectsReactions()
    
    static let zeroCategory:UInt32 = 0x0
    static let shooterCategory:UInt32 =  0x1 << 0;
    static let burgerCategory:UInt32 = 0x1 << 1;
    static let burgerPartCategory:UInt32 = 0x1 << 2;
    static let obstacleCategory:UInt32 = 0x1 << 3;

    static let frameCategory:UInt32 = 0x1 << 4;
    static let bottomCategory:UInt32 = 0x1 << 5;
    
    static let edgeCategory:UInt32 = 0x1 << 6;
    static let addOnCategory:UInt32 = 0x1 << 7;
    static let attachedAddonCategory:UInt32 = 0x1 << 8;
    static let shooterBoxCategory:UInt32 = 0x1 << 9;
    let sound = SoundPlayer()

    
}



struct Constants
{
    
    struct NotificationKey
    {
        static let Welcome = "kWelcomeNotif"
    }
    
    struct Path
    {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] //changed from as to as! with the new Swift
        static let Tmp = NSTemporaryDirectory()
    }
}

