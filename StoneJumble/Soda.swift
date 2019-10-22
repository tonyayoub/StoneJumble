//
//  Soda.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 7/2/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class Soda: Obstacle
{

    override func doActionsAfterHit(hitter: SJSpriteNode, hittingPoint: CGPoint)
    {
        

        SJDirector.shared.sound.playLevelSound(sound: .sodaHit)
 

        
        
    }

    override func destroyerList() -> [AddonType]
    {
        return [AddonType.water, AddonType.pea]
    }
}
