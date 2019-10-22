//
//  Ketchup.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 7/2/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class Ketchup: Obstacle
{
    override func doActionsAfterHit(hitter: SJSpriteNode, hittingPoint: CGPoint)
    {
//        if(isBeingHit)
//        {
//            return
//        }
//        else
//        {
//            isBeingHit = true
//        }

        if let shooter = hitter as? Shooter
        {
            if var vel = shooter.physicsBody?.velocity
            {
                vel = multiplyVector(vel, value: 0.01)
                shooter.physicsBody?.velocity = vel
            }
            //shooter.run(SKAction.wait(forDuration: 0.01), completion: {shooter.physicsBody?.velocity = CGVector.zero})
            SJDirector.shared.sound.playLevelSound(sound: .ketchupStick)
         //   let ampl = Int(shooter.size.width * 0.05)
         //   shooter.run(SKAction.shake(shooter.position, duration: 0.1, amplitudeX: ampl, amplitudeY: ampl), completion: {self.isBeingHit = false})

        }
       
    }
    
    override func destroyerList() -> [AddonType]
    {
        return [AddonType.tomatoe, AddonType.pea]
    }
    
    
    

}
