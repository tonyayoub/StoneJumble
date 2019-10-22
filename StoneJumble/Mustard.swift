//
//  Mustard.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 7/2/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class Mustard: Obstacle
{
    var mustardingOneBurgerAlready = false
    override func doActionsAfterHit(hitter: SJSpriteNode, hittingPoint: CGPoint)
    {

        
        if mustardingOneBurgerAlready
        {
            return
        }
        else
        {
            mustardingOneBurgerAlready = true
        }
        
        if let scene = SJLevelScene.currentLevelScene
        {
            
            let burgers = scene.allTargets()
            if burgers.count < 1
            {
                return;
            }
            var allBurgersAreTopStrength = true
            for burger in burgers
            {
                if burger.strength < SJDirector.maxStrength //at least one burger can be ketchupped
                {
                    allBurgersAreTopStrength = false
                    break
                }
            }
            if allBurgersAreTopStrength
            {
                self.mustardingOneBurgerAlready = false
                return;
            }
            var oldBurger = burgers[0] //dummy choice
            var numberOfTrials = 0
            while true
            {
                numberOfTrials += 1
                if numberOfTrials >= 10
                {
                    self.mustardingOneBurgerAlready = false
                    return;
                }
                let chosenBurgerIndex = Int(arc4random_uniform(UInt32(burgers.count)))
                oldBurger = burgers[chosenBurgerIndex]
                if (oldBurger.isBeingMustarded || oldBurger.strength >= SJDirector.maxStrength
                    || oldBurger.isBeingHit || oldBurger.isBeingDestroyed)
                {
                    if burgers.count == 1 //it is the only burger in the scene
                    {
                        self.mustardingOneBurgerAlready = false
                        return;
                    }
                    else // search for another burgers
                    {
                        continue;
                    }
                }
                else
                {
                    oldBurger.isBeingMustarded = true
                    break
                }
                
                
            }
            var newStrength = oldBurger.strength
            //      oldBurger.physicsBody = nil
            newStrength += 1
            
            guard let newBurger = Burger.make(objectSpec: "\(newStrength)") as? Burger else
            {
                self.mustardingOneBurgerAlready = false
                oldBurger.isBeingMustarded = false
                return
            }
            
            newBurger.updateCollisionMask()
            newBurger.position = oldBurger.position
            newBurger.zPosition = oldBurger.zPosition + 1

            
            //newBurger.isHidden = true
            
            let y2 = newBurger.position.y
            let y1 = self.position.y
            
            let x2 = newBurger.position.x
            let x1 = self.position.x
            
            let tanAngle = (y2 - y1) / (x2 - x1)
            var angle = atan(tanAngle)
            
            
            if (x2 >= x1)
            {
                angle = angle - CGFloat.pi/2
            }
            else
            {
                angle = CGFloat.pi/2 + angle
                
            }
            
            
            let drop = SKSpriteNode(imageNamed: "redDrop")
//            drop.run(SKAction.wait(forDuration: 5), completion: {
//                drop.isHidden = true
//            })
            self.addChild(drop)
            drop.position.y += self.size.height/2
            drop.zPosition = 99
            drop.isHidden = true
            let dropTimeToReach:Double = 0.5
            let rotationTime = 0.25
            SJDirector.shared.sound.playLevelSound(sound: SoundEvent.mustardShoot)

            self.run(SKAction.sequence([
                SKAction.rotate(toAngle: angle*1.25, duration: rotationTime),
                SKAction.rotate(toAngle: angle, duration: rotationTime*0.2),
                SKAction.run {
                    drop.isHidden = false
                    drop.move(toParent: self.parent!)
                    drop.zPosition = 99
                    drop.run(SKAction.move(to: oldBurger.position, duration: dropTimeToReach), completion: {
                        drop.removeFromParent()
                    })

                    },
                SKAction.wait(forDuration: dropTimeToReach),
                SKAction.run({
                    self.showEmitter(emitterFile: "red", position: oldBurger.position, lifetime: 3)
                }),
                SKAction.wait(forDuration: 0.5),
                SKAction.run({oldBurger.run(SKAction.shake(oldBurger.position, duration: 2))}),
                SKAction.run({
                    SJLevelScene.currentLevelScene?.container.addChild(newBurger)
                    oldBurger.removeFromParent()
                }),
                SKAction.rotate(toAngle: angle * -0.25, duration: rotationTime),
                SKAction.rotate(toAngle: 0, duration: rotationTime*0.2),

                SKAction.run({
                    // print("will make mustardingOneBurgerAlready = false")
                    self.mustardingOneBurgerAlready = false
                    
                })
                ]))
            //scene.container.addChild(newBurger)
            
        }
    }

    
    override func destroyerList() -> [AddonType]
    {
        return [AddonType.lemon, AddonType.pea]
    }
}
