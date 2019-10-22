//
//  HolderNode.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 3/29/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class HolderNode: SKNode
{
    static let movingOutName = "movingOut"

    func fadeOutWithDirection(direction: CGFloat)
    {
        
        self.name = HolderNode.movingOutName
        self.removeFromParent()
    }
    

}
