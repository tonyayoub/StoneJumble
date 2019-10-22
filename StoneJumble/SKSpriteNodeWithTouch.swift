//
//  SKPSpriteNodeWithTouch.swift
//  BurgerInvasion
//
//  Created by Tony Sameh on 1/4/18.
//  Copyright © 2018 amahy. All rights reserved.
//

import SpriteKit

class SKSpriteNodeWithTouch: SKSpriteNode
{
    var onTouched:(()->Void)?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let performAction = onTouched
        {
            self.isUserInteractionEnabled = false
            performAction()
        }
    }
}
