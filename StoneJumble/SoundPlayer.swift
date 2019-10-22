//
//  SoundPlayer.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 1/14/16.
//  Copyright © 2016 amahy. All rights reserved.
//

import SpriteKit
/*
 class Singleton {
 static let sharedInstance: Singleton = {
 let instance = Singleton()
 
 // setup code
 
 return instance
 }()
 }
 */

enum SoundEvent
{
    case sodaHit
    case levelStart
    case tapShooter
    case reflection
    case targetHit
    case partTouchesFloor
    case targetExplodes
    case obstacleNoMove
    case obstacleExplode
    case ketchupStick
    case friesDouble
    case mustardShoot
}

class SoundPlayer: NSObject
{
    

  
    let levelStartAudio = SKAction.playSoundFileNamed("bell", waitForCompletion: false)
    let tapAudio = SKAction.playSoundFileNamed("tap", waitForCompletion: false)
    let touchFloorAudio = SKAction.playSoundFileNamed("touchFloor", waitForCompletion: false)
    let hitTargetAudio = SKAction.playSoundFileNamed("hit", waitForCompletion: false)
    let reflectionAudio = SKAction.playSoundFileNamed("reflection", waitForCompletion: false)
    let explosionAudio = SKAction.playSoundFileNamed("explode", waitForCompletion: false)
    let ketchupShoot = SKAction.playSoundFileNamed("ketchup", waitForCompletion: false)
    let mustardShoot = SKAction.playSoundFileNamed("mustard", waitForCompletion: false)
    let friesDouble = SKAction.playSoundFileNamed("fries", waitForCompletion: false)
    let sodaStop = SKAction.playSoundFileNamed("soda", waitForCompletion: false)
    let water = SKAction.playSoundFileNamed("water", waitForCompletion: false)
    let obstacleExplode = SKAction.playSoundFileNamed("obstacleExplode", waitForCompletion: false)
   

    func runSoundAction(owner: SKNode, soundAction: SKAction)
    {
        if !NPDirector.shared.soundEnabled
        {
            return
        }
        owner.run(soundAction)
    }
 

    //not menu sound
    func playLevelSound(sound: SoundEvent)
    {
        if !NPDirector.shared.soundEnabled
        {
            return
        }
        guard let owner = SJLevelScene.currentLevelScene else
        {
            return
        }
        switch sound
        {
        case .sodaHit:
            owner.run(sodaStop)
        case .levelStart:
            owner.run(levelStartAudio)
        case .tapShooter:
            owner.run(tapAudio)
        case .targetHit:
            owner.run(hitTargetAudio)
        case .partTouchesFloor:
            owner.run(touchFloorAudio)
        case .reflection:
            owner.run(reflectionAudio)
        case .targetExplodes:
            owner.run(explosionAudio)
        case .ketchupStick:
            owner.run(ketchupShoot)
        case .mustardShoot:
            owner.run(mustardShoot)
        case .friesDouble:
            owner.run(friesDouble)
        case .obstacleExplode:
            owner.run(obstacleExplode)
        default:
            return;
        }
    }


}
